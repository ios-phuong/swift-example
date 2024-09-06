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
    
    var cancellable = Set<AnyCancellable>()
    
    func fetchUserIDs() -> AnyPublisher<[String], Never> {
        Just(["apple", "google", "facebook"])
            .eraseToAnyPublisher()
    }
    
    func fetch() {
        fetchUserIDs()
            .flatMap { userIDs in
                Publishers.MergeMany(userIDs.map { self.fetchRepositories(from: $0) })
            }
            .receive(on: DispatchQueue.main)
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
    
    func fetchRepositories(from name: String) -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/orgs/\(name)/repos")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
