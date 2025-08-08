//
//  FavoritesManager.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation


protocol FavoritesManaging {
    func getFavorites() -> [GitHubUser]
    func add(user: GitHubUser)
    func remove(user: GitHubUser)
    func toggle(user: GitHubUser)
    func isFavorite(user: GitHubUser) -> Bool
}

final class FavoritesManager: FavoritesManaging {
    static let shared: FavoritesManaging = FavoritesManager()
    private let key = "favorite_users"

    func getFavorites() -> [GitHubUser] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let users = try? JSONDecoder().decode([GitHubUser].self, from: data) else { return [] }
        return users
    }

    func add(user: GitHubUser) {
        var list = getFavorites()
        guard !list.contains(user) else { return }
        list.append(user)
        save(list); notify()
    }

    func remove(user: GitHubUser) {
        var list = getFavorites()
        list.removeAll { $0.id == user.id }
        save(list); notify()
    }

    func toggle(user: GitHubUser) {
        isFavorite(user: user) ? remove(user: user) : add(user: user)
    }

    func isFavorite(user: GitHubUser) -> Bool { getFavorites().contains(user) }

    private func save(_ list: [GitHubUser]) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    private func notify() { NotificationCenter.default.post(name: .favoritesChanged, object: nil) }
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
