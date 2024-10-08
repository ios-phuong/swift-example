//
//  MovieListViewController.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import UIKit

protocol MovieListViewControllerProtocol: AnyObject {
    func reloadData()
    func setupTableView()
}

final class MovieListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: MovieListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        
        MovieListRouter.createModule(movieListVC: self)
        presenter.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveReloadNotification(notification:)), name:  Notification.Name("RELOAD_NOTIFICATION"), object: nil)
    }
    
    @objc func didReceiveReloadNotification(notification: NSNotification) {
        if let dict = notification.object as? [String : Any], let movie = dict["movie"] as? Movie {
            self.presenter?.refreshData(movieObj: movie)
        }
    }
    
    @IBAction private func onSortButtonTapped(_ sender: UIBarButtonItem) {
        presenter.showActionSheet()
    }
}

extension MovieListViewController : MovieListViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieListTableCell.self)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieListTableCell.self, for: indexPath)
        cell.selectionStyle = .none
        if let movie = presenter.movie(indexPath.row) {
            cell.cellPresenter = MovieListCellPresenter(view: cell, movie: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(index: indexPath.row)
    }
}
