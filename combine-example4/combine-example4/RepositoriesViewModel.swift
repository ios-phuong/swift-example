//
//  RepositoriesViewModel.swift
//  combine-example4
//
//  Created by phuong.doan on 9/4/24.
//

import Foundation
import Combine

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
}

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    private var cancellables = Set<AnyCancellable>()

    
    func fetch() {
        // URLs for 5 network requests (example URLs)
        let url1 = URL(string: "https://api.github.com/orgs/apple/repos")!
        let url2 = URL(string: "https://api.github.com/orgs/google/repos")!
        let url3 = URL(string: "https://api.github.com/orgs/microsoft/repos")!
        let url4 = URL(string: "https://api.github.com/orgs/facebook/repos")!
//        let url5 = URL(string: "https://api.github.com/orgs/amazon/repos")!

        // Publishers for each network request
        let publisher1 = fetchRepositories(from: url1)
        let publisher2 = fetchRepositories(from: url2)
        let publisher3 = fetchRepositories(from: url3)
        let publisher4 = fetchRepositories(from: url4)
//        let publisher5 = fetchRepositories(from: url5)
        
        let combinedPublisher = publisher1
            .zip(publisher2, publisher3, publisher4)
        
        // Subscribe to the combined publisher
        let cancellable = combinedPublisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("All network requests completed successfully.")
                    case .failure(let error):
                        print("Failed with error: \(error)")
                    }
                },
                receiveValue: { (repos1, repos2, repos3, repos4) in
                    print("Fetched repositories from 5 requests:")
                    print("Request 1: \(repos1.count) repositories")
                    print("Request 2: \(repos2.count) repositories")
                    print("Request 3: \(repos3.count) repositories")
                    print("Request 4: \(repos4.count) repositories")
//                    print("Request 5: \(repos5.count) repositories")
                }
            )
    }
    
    
    func fetchRepositories(from url: URL) -> AnyPublisher<[Repository], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
