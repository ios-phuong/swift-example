//
//  NetworkService.swift
//  combine-example2
//
//  Created by phuong.doan on 9/4/24.
//

import Foundation
import Combine

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
}

class NetworkService {
    func fetchRepositories() -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/orgs/apple/repos")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
