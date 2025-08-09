//
//  HomeViewController.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import UIKit

final class HomeViewController: UIViewController, AlertPresenting, EmptyStatePresentable {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var _viewModel: HomeViewModelProtocol?
    private let rateLimitBanner = RateLimitBannerViewController()

    var viewModel: HomeViewModelProtocol {
        guard let vm = _viewModel else { fatalError("configure(viewModel:) çağrılmadı") }
        return vm
    }
    func configure(viewModel: HomeViewModelProtocol) {
        self._viewModel = viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub İsim Arama"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        bindVM()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyBlackToWhiteGradient(.diagonal)
    }
    
    private func bindVM() {
        _viewModel?.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            if self.viewModel.users.isEmpty {
                self.showEmptyState(in: self.view, message: "Sonuç bulunamadı.\nFarklı bir kullanıcı adı deneyin.")
            } else {
                self.hideEmptyState(from: self.view)
            }
        }
        _viewModel?.onError = { [weak self] msg in
            self?.presentError(msg)
        }
        _viewModel?.onRateLimit = { [weak self] until in
            guard let self = self else { return }
            self.rateLimitBanner.show(in: self, until: until)  
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let q = searchBar.text, !q.isEmpty else { return }
        viewModel.search(query: q)
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.users[indexPath.row]
        let cell = tv.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.configure(with: user, isFavorite: viewModel.isFavorite(user: user))
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.toggleFavorite(user: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        let vm = DetailViewModel(user: user)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        vc.configure(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
