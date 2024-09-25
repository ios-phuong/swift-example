//
//  MovieListRouter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation
import UIKit

protocol MovieListRouterProtocol: AnyObject {
    func navigate(_ route: MovieListRoutes)
}

enum MovieListRoutes {
    case detail(movie: Movie)
}

class MovieListRouter {
    
    
}

extension MovieListRouter : MovieListRouterProtocol {
    func navigate(_ route: MovieListRoutes) {
        
    }
}
