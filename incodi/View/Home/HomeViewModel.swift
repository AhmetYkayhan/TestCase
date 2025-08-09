//
//  HomeViewModel.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var users: [GitHubUser] { get }
    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onRateLimit: ((Date) -> Void)? { get set }

    func search(query: String)
    func toggleFavorite(user: GitHubUser)
    func isFavorite(user: GitHubUser) -> Bool
}

final class HomeViewModel: HomeViewModelProtocol {
    private let service: GitHubApiServiceProtocol
    private let favorites: FavoritesManageProtocol
    
    private(set) var users: [GitHubUser] = []
    
    private var rateLimitUntil: Date?
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onRateLimit: ((Date) -> Void)?

    init(service: GitHubApiServiceProtocol = GitHubApiService(),
         favoritesManager: FavoritesManageProtocol = FavoritesManager.shared) {
        self.service = service
        self.favorites = favoritesManager
        NotificationCenter.default.addObserver(self, selector: #selector(favsChanged), name: .favoritesChanged, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func search(query: String) {
        if let until = rateLimitUntil, Date() < until {
            onRateLimit?(until)
            return
        }
        
        service.searchUsers(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let list):
                        self?.users = list
                        self?.onUpdate?()
                    case .failure(let err):
                        if case ApiError.rateLimited(let until) = err {
                            self?.onRateLimit?(until)
                        } else {
                            self?.onError?("Arama başarısız: \(err.localizedDescription)")
                        }
                        self?.users = []
                        self?.onUpdate?()
                }
            }
        }
    }
    
    func toggleFavorite(user: GitHubUser) {
        favorites.toggle(user: user)
    }
    
    func isFavorite(user: GitHubUser) -> Bool {
        favorites.isFavorite(user: user)
    }

    @objc private func favsChanged() {
        onUpdate?()
    }
}
