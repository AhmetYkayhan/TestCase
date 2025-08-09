//
//  DetailViewModel.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation

protocol DetailViewModelProtocol: AnyObject {
    var user: GitHubUser { get }
    var isFavorite: Bool { get }
    var onFavoriteStatusChanged: (() -> Void)? { get set }
    
    func toggleFavorite()
}

final class DetailViewModel: DetailViewModelProtocol {
    private let favorites: FavoritesManageProtocol
    private(set) var user: GitHubUser
    var onFavoriteStatusChanged: (() -> Void)?
    var isFavorite: Bool { favorites.isFavorite(user: user) }

    init(user: GitHubUser, favoritesManager: FavoritesManageProtocol = FavoritesManager.shared) {
        self.user = user
        self.favorites = favoritesManager
        NotificationCenter.default.addObserver(self, selector: #selector(favsChanged), name: .favoritesChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func toggleFavorite() {
        favorites.toggle(user: user)
        onFavoriteStatusChanged?()
    }
    
    @objc private func favsChanged() {
        onFavoriteStatusChanged?()
    }
}
