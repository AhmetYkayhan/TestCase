//
//  UserCell.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import UIKit
import Kingfisher

final class UserCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var onFavoriteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerCurve = .circular
        avatarImageView.clipsToBounds = true
        favoriteButton.addTarget(self, action: #selector(favTap), for: .touchUpInside)
    }
    
    func configure(with user: GitHubUser, isFavorite: Bool) {
        nameLabel.text = user.login
        avatarImageView.kf.setImage(with: URL(string: user.avatarURL ?? "dash"))
        let name = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: name), for: .normal)
    }
    
    @objc private func favTap() {
        onFavoriteTapped?()
    }
}
