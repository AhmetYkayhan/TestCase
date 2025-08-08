//
//  RateLimitBannerViewController.swift
//  incodi
//
//  Created by Yasin Kayhan on 8.08.2025.
//

import UIKit

class RateLimitBannerViewController {
    private var container: UIView?
    private var label: UILabel?
    private var timer: Timer?
    private var until: Date = Date()
    
    func show(in vc: UIViewController, until: Date) {
        hide()
        self.until = until
        
        let host = UIView()
        host.translatesAutoresizingMaskIntoConstraints = false
        host.backgroundColor = UIColor.systemRed.withAlphaComponent(0.95)
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textAlignment = .center
        
        host.addSubview(lbl)
        vc.view.addSubview(host)
        
        NSLayoutConstraint.activate([
            host.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            host.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            host.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            lbl.topAnchor.constraint(equalTo: host.topAnchor, constant: 8),
            lbl.bottomAnchor.constraint(equalTo: host.bottomAnchor, constant: -8),
            lbl.leadingAnchor.constraint(equalTo: host.leadingAnchor, constant: 12),
            lbl.trailingAnchor.constraint(equalTo: host.trailingAnchor, constant: -12)
        ])
        
        self.container = host
        self.label = lbl
        
        updateLabel()
        
        host.transform = CGAffineTransform(translationX: 0, y: -host.bounds.height - 40)
        UIView.animate(withDuration: 0.25) { host.transform = .identity }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func hide() {
        timer?.invalidate()
        timer = nil
        if let host = container {
            UIView.animate(withDuration: 0.2, animations: {
                host.alpha = 0
            }, completion: { _ in
                host.removeFromSuperview()
            })
        }
        container = nil
        label = nil
    }
    
    private func tick() {
        if Date() >= until {
            hide()
        } else {
            updateLabel()
        }
    }
    
    private func updateLabel() {
        let remaining = Int(max(0, until.timeIntervalSinceNow))
        let mm = remaining / 60
        let ss = remaining % 60
        label?.text = "GitHub rate limit aşıldı. Yenileme: \(String(format: "%02d:%02d", mm, ss))"
    }
}
