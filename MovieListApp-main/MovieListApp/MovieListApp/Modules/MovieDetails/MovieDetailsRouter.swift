//
//  MovieDetailsRouter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation
import UIKit

protocol MovieDetailRouterProtocol: AnyObject {
    func navigate(_ route: MovieDetailRoutes)
}

enum MovieDetailRoutes {
    case detail(movieObj: Movie)
    case openURL(playUrl: URL)
}

class MovieDetailsViewRouter {

    weak var viewController: MovieDetailsViewController?
    
    static func createModule(movie : Movie) -> MovieDetailsViewController {
        let viewController = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        let interactor = MovieDetailViewInteractor()
        let router = MovieDetailsViewRouter()
        let presenter = MovieDetailPresenter(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
        viewController.presenter.movieDetail = movie
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}

extension MovieDetailsViewRouter: MovieDetailRouterProtocol {
    func navigate(_ route: MovieDetailRoutes) {
        switch route {
        case .detail(let movieObj):
            let detailVC = MovieDetailsViewRouter.createModule(movie: movieObj)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        case .openURL(let url):
            UIApplication.shared.open(url)
        }
    }
}

