//
//  MovieListCellPresenterProtocol.swift
//  MovieListApp
//
//  Created by phuong.doan on 05/11/2022.
//

import Foundation
import UIKit

protocol MovieListCellPresenterProtocol: AnyObject {
    func load()
}

class MovieListCellPresenter {
    weak var view: MovieListCellProtocol?
    private let movie: Movie
    
    init(view: MovieListCellProtocol?, movie: Movie) {
        self.view = view
        self.movie = movie
    }
}

extension MovieListCellPresenter : MovieListCellPresenterProtocol {
    func load() {
        
        
    }
}
