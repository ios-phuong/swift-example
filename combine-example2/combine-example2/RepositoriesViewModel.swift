//
//  RepositoriesViewModel.swift
//  combine-example2
//
//  Created by phuong.doan on 9/4/24.
//

import Foundation
import Combine

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService()

    func loadRepositories() {
        networkService.fetchRepositories()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching repositories: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] repositories in
                self?.repositories = repositories
            })
            .store(in: &cancellables)
    }
}
