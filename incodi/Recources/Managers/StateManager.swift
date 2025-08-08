//
//  StateManager.swift
//  incodi
//
//  Created by Yasin Kayhan on 8.08.2025.
//

import UIKit

protocol EmptyStatePresentable {}
private let emptyStateTag = 987_654

extension EmptyStatePresentable where Self: UIViewController {
    func showEmptyState(in container: UIView, message: String) {
        hideEmptyState(from: container)

        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.tag = emptyStateTag
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -24)
        ])
    }

    func hideEmptyState(from container: UIView) {
        container.viewWithTag(emptyStateTag)?.removeFromSuperview()
    }
}
