//
//  MovieDetailsPresenter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

protocol MovieDetailsViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    var movieDetail : Movie? { get set }
}

final class MovieDetailPresenter: MovieDetailsViewPresenterProtocol {

    unowned var view: MovieDetailsViewControllerProtocol
    let router: MovieDetailRouterProtocol
    let interactor: MovieDetailViewInteractorProtocol
    var movieDetail: Movie?

    init(
        view: MovieDetailsViewControllerProtocol,
        router: MovieDetailRouterProtocol,
        interactor: MovieDetailViewInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        view.setupTableView()
    }
}

extension MovieDetailPresenter: MovieDetailViewInteractorOutputProtocol {}
