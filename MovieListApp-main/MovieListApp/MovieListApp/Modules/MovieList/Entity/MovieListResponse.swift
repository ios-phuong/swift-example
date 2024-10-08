//
//  MovieListResponse.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

struct MovieResponse: Codable {
    let movieList: [Movie]?
}

struct Movie:  Codable {
    let title: String
    let id: Int
    let description: String
    let rating: Double
    let duration: String
    let genre: String
    let releasedDate: String
    var watchListAdded : Bool? {
        guard let isWatchList = UserDefaults.standard.value(forKey: "\(id)") as? Bool else {
           return false
        }
        return isWatchList
    }
    var releaseDateObj : Date? {
        releasedDate.convertToDate()
    }
    let trailerLink : String
    var trailerLinkUrl: URL? {
        return URL(string: trailerLink)
    }
}

enum JSONParseError: Error {
    case fileNotFound
    case dataInitialization(error: Error)
    case decoding(error: Error)
}

enum SortType: Int {
    case title = 0
    case releaseDate = 1
}
