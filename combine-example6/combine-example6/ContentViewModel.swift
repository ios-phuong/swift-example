//
//  ContentViewModel.swift
//  combine-example6
//
//  Created by phuong.doan on 9/5/24.
//

import Foundation
import Combine

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
}

class ContentViewModel: ObservableObject {
    
    @Published var repositories: [Repository] = []

    let userIDs = [
        "apple", 
        "google",
        "facebook"
    ].publisher
    var cancellable = Set<AnyCancellable>()
    
    func fetchRepositories(from name: String) -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/orgs/\(name)/repos")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetch() {
        userIDs
            .receive(on: DispatchQueue.main)
            .flatMap { name in
                self.fetchRepositories(from: name)
                    .receive(on: DispatchQueue.main)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching repositories.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { repos in
                self.repositories.append(contentsOf: repos)
            })
            .store(in: &cancellable)
    }
}
