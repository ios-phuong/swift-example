//
//  MovieDetailsViewController.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import UIKit

protocol MovieDetailsViewControllerProtocol: AnyObject {
    func setupTableView()
}

class MovieDetailsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var movieId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        
    }
}

extension MovieDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : MovieDetailsHeaderView = MovieDetailsHeaderView.fromNib()
        
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension MovieDetailsViewController : MovieDetailsViewControllerProtocol {
    func setupTableView() {
        tableView.delegate = self
        tableView.register(viewType: MovieDetailsHeaderView.self)
        if #available(iOS 15.0, *) {
          tableView.sectionHeaderTopPadding = 0
        }
    }
}
