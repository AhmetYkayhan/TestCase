//
//  UIViewExtension.swift
//  incodi
//
//  Created by Yasin Kayhan on 8.08.2025.
//

import UIKit

extension UIView {
    enum GradientDirection { case vertical, horizontal, diagonal }

    func applyBlackToWhiteGradient(_ direction: GradientDirection = .vertical) {
        layer.sublayers?.removeAll(where: { $0.name == "bwGradient" })

        let g = CAGradientLayer()
        g.name = "bwGradient"
        g.frame = bounds
        g.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        g.locations = [0.0, 1.0]

        switch direction {
        case .vertical:
            g.startPoint = CGPoint(x: 0.5, y: 0.0)
            g.endPoint   = CGPoint(x: 0.5, y: 1.0)
        case .horizontal:
            g.startPoint = CGPoint(x: 0.0, y: 0.5)
            g.endPoint   = CGPoint(x: 1.0, y: 0.5)
        case .diagonal:
            g.startPoint = CGPoint(x: 0.0, y: 0.0)
            g.endPoint   = CGPoint(x: 1.0, y: 1.0)
        }

        layer.insertSublayer(g, at: 0)
    }
}
