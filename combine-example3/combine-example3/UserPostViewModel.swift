//
//  UserPostViewModel.swift
//  combine-example3
//
//  Created by phuong.doan on 9/4/24.
//

import SwiftUI
import Combine

struct User: Codable {
    let id: Int
    let name: String
}

struct Post: Codable {
    let userId: Int
    let title: String
}

class UserPostViewModel: ObservableObject {
    @Published var user: User?
    @Published var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUserAndPosts(userId: Int) {
        let userPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)")!)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        let postsPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(userId)")!)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        Publishers.Zip(userPublisher, postsPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] user, posts in
                self?.user = user
                self?.posts = posts
            })
            .store(in: &cancellables)
    }
}
