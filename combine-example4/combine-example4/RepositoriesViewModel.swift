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
        let urls = [
            URL(string: "https://api.github.com/orgs/apple/repos")!,
            URL(string: "https://api.github.com/orgs/google/repos")!,
            URL(string: "https://api.github.com/orgs/microsoft/repos")!,
            URL(string: "https://api.github.com/orgs/facebook/repos")!
        ]
        let publishers = urls.map({ fetchRepositories(from: $0) })
        let publisherArr = urls.map(fetchRepositories(from:))
        
        Publishers.MergeMany(publisherArr)
            .collect() // Collect all arrays of repositories into a single array
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching repositories: \(error)")
                case .finished:
                    print("Finished fetching repositories.")
                }
            }, receiveValue: { repositoriesArray in
                // Flatten the arrays into a single array
                self.repositories = repositoriesArray.flatMap { $0 }
            })
            .store(in: &cancellables)
    }
    
    
    func fetchRepositories(from url: URL) -> AnyPublisher<[Repository], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
//            .tryMap({ (data: Data, response: URLResponse) in
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                    print("JSON Response from \(url): \(json)")
//                } else {
//                    print("data invalid")
//                }
//                return data
//            })
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
