//
//  MovieListTableCell.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import UIKit

protocol MovieListCellProtocol: AnyObject {
    func setMovieImage(_ image : UIImage)
    func setWatchListButton(_ isWatchListAdded: Bool)
    func setDurationNGenreLabel(_ text: String)
    func setTitleLabel(_ text: String)
}

class MovieListTableCell: UITableViewCell {
    
    @IBOutlet private weak var movieImage: SwiftShadowImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeNGenreLabel: UILabel!
    @IBOutlet private weak var onMyWatchList: UILabel!

    var cellPresenter: MovieListCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
}

extension MovieListTableCell: MovieListCellProtocol {
    func setTitleLabel(_ text: String) {
        titleLabel.text = text
        titleLabel.layoutIfNeeded()
    }
    
    func setMovieImage(_ image: UIImage) {
        movieImage.image = image
    }
    
    func setWatchListButton(_ isWatchListAdded: Bool) {
        self.onMyWatchList.isHidden = !isWatchListAdded
    }
    
    func setDurationNGenreLabel(_ text: String) {
        timeNGenreLabel.text = text
    }
}
