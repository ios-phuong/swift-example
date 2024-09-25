//
//  MovieListTableCell.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import UIKit

final class MovieListTableCell: UITableViewCell {
    
    @IBOutlet private weak var movieImage: SwiftShadowImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeNGenreLabel: UILabel!
    @IBOutlet private weak var onMyWatchList: UILabel!

    func configureCell(movie: Movie) {
        setTitleLabel(movie.title)
        if let movieImage = UIImage(named: "\(movie.id)") {
            setMovieImage(movieImage)
        }
        setDurationNGenreLabel("\(movie.duration) -  \(movie.genre)")
        setWatchListButton(movie.watchListAdded ?? false)
    }
}

extension MovieListTableCell {
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
