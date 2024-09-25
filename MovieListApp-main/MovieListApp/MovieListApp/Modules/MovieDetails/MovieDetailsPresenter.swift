//
//  MovieDetailsPresenter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation
//MARK: - Protocols +  MovieDetailsViewPresenterProtocol
protocol MovieDetailsViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    var movieDetail : MovieList? { get set }
}

final class MovieDetailPresenter: MovieDetailsViewPresenterProtocol {

    unowned var view: MovieDetailsViewControllerProtocol?
    let router: MovieDetailRouterProtocol!
    let interactor: MovieDetailViewInteractorProtocol!
    var movieDetail: MovieList?

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
        view?.setupTableView()
    }
    
    func viewWillAppear() {
        view?.setUpView()
    }
}

//MARK: - Extension +  MovieDetailViewInteractorOutputProtocol
extension MovieDetailPresenter : MovieDetailViewInteractorOutputProtocol {
    
}
