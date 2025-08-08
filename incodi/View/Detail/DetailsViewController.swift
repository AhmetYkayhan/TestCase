//
//  DetailsViewController.swift
//  incodi
//
//  Created by Yasin Kayhan on 8.08.2025.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var openProfileButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var viewModel: DetailViewModelProtocol!
    
    func configure(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kullanıcı Detayı"
        
        avatarImageView.kf.setImage(with: URL(string: viewModel.user.avatar_url))
        usernameLabel.text = viewModel.user.login
        updateFavoriteButton()
        
        viewModel.onFavoriteStatusChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.updateFavoriteButton()
            }
        }
        avatarImageView.layer.cornerRadius = 50
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyBlackToWhiteGradient(.diagonal)
    }
    
    private func updateFavoriteButton() {
        let name = viewModel.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: name), for: .normal)
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        viewModel.toggleFavorite()
    }
    
    @IBAction func openProfileButtonTapped(_ sender: UIButton) {
        if let url = URL(string: viewModel.user.html_url) { UIApplication.shared.open(url) }
    }
}
