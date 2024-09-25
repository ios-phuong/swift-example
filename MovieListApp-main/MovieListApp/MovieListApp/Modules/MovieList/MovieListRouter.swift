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
    
    weak var viewController: MovieListViewController?
    
    static func createModule(movieListVC: MovieListViewController) {
        let interactor = ListInteractor()
        let router = MovieListRouter()
        let presenter = MovieListPresenter(viewController: movieListVC, router: router, interactor: interactor)
        movieListVC.presenter = presenter
        interactor.presenter = presenter
        router.viewController = movieListVC
    }
}

extension MovieListRouter : MovieListRouterProtocol {
    func navigate(_ route: MovieListRoutes) {
        switch route {
        case .detail(let movieObj):
            let detailVC = MovieDetailsViewRouter.createModule(movie: movieObj)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
