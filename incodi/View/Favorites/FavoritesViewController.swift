//
//  FavoriteViewController.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import UIKit

final class FavoritesViewController: UIViewController, EmptyStatePresentable {
    @IBOutlet weak var tableView: UITableView!
    
    private var _viewModel: FavoritesViewModelProtocol?
    var viewModel: FavoritesViewModelProtocol {
        guard let vm = _viewModel else { fatalError("configure(viewModel:) çağrılmadı") }
        return vm
    }
    
    func configure(viewModel: FavoritesViewModelProtocol) {
        self._viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorilerim"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        _viewModel?.onUpdate = {
            [weak self] in self?.tableView.reloadData()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyBlackToWhiteGradient(.diagonal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
        if viewModel.favoriteUsers.isEmpty {
            showEmptyState(in: view, message: "Henüz favori eklemediniz.")
        } else {
            hideEmptyState(from: view)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteUsers.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.favoriteUsers[indexPath.row]
        let cell = tv.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.configure(with: user, isFavorite: true)
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.removeFavorite(user: user)
        }
        return cell
    }
    
    func tableView(_ tv: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = viewModel.favoriteUsers[indexPath.row]
            viewModel.removeFavorite(user: user)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.favoriteUsers[indexPath.row]
        let vm = DetailViewModel(user: user)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        vc.configure(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
