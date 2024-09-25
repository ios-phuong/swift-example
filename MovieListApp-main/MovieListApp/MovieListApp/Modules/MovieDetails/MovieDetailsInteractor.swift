//
//  MovieDetailsInteractor.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

protocol MovieDetailViewInteractorProtocol: AnyObject {
}


protocol MovieDetailViewInteractorOutputProtocol: AnyObject {
}


final class MovieDetailViewInteractor {
    var output: MovieDetailViewInteractorOutputProtocol?
}

extension MovieDetailViewInteractor : MovieDetailViewInteractorProtocol {
}
