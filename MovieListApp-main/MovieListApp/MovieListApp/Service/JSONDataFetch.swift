//
//  ServiceManager.swift
//  MovieListApp
//
//  Created by phuong.doan on 05/11/2022.
//

import Foundation

typealias MovieListResult = Result<MovieResponse, JSONParseError>

protocol MovieServiceProtocol {
    func fetchMovieList(completionHandler: @escaping (MovieListResult) -> ())
}

struct MovieService: MovieServiceProtocol {
    func fetchMovieList(completionHandler: @escaping (MovieListResult) -> ()) {
        JSONManager.shared.getDatafrom(localJSON: "ListJSON", decodeToType: MovieResponse.self, completionHandler: completionHandler)
    }
}


