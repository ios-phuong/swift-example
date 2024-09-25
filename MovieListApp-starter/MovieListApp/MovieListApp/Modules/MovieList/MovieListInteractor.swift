//
//  MovieListInteractor.swift
//  MovieListApp
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchMoviesList()
    func sortMoviesList(sortType : SortType, movies :  [Movie])

}


class ListInteractor {
    
    
}

extension ListInteractor: MovieListInteractorProtocol {
    func sortMoviesList(sortType : SortType, movies :  [Movie]) {
        
        
    }
    
    func fetchMoviesList() {
        
        
    }
}
