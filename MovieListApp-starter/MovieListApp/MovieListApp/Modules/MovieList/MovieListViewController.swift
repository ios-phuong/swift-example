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

class MovieListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        
        
    }
    
    
    
    @IBAction private func onSortButtonTapped(_ sender: UIBarButtonItem) {
        
        
        
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
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieListTableCell.self, for: indexPath)
        cell.selectionStyle = .none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
