//
//  FavoritesViewModel.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation
protocol FavoritesViewModelProtocol {
    var favoriteUsers: [GitHubUser] { get }
    var onUpdate: (() -> Void)? { get set }
    
    func refresh()
    func removeFavorite(user: GitHubUser)
    func isFavorite(user: GitHubUser) -> Bool
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    private let favorites: FavoritesManaging
    private(set) var favoriteUsers: [GitHubUser] = []
    
    var onUpdate: (() -> Void)?

    init(favoritesManager: FavoritesManaging = FavoritesManager.shared) {
        self.favorites = favoritesManager
        NotificationCenter.default.addObserver(self, selector: #selector(favsChanged), name: .favoritesChanged, object: nil)
        refresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func refresh() {
        favoriteUsers = favorites.getFavorites(); onUpdate?()
    }
    
    func removeFavorite(user: GitHubUser) {
        favorites.remove(user: user)
    }
    
    func isFavorite(user: GitHubUser) -> Bool {
        favorites.isFavorite(user: user)
    }

    @objc private func favsChanged() {
        refresh()
    }
}
