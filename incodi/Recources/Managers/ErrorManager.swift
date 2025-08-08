//
//  ErrorManager.swift
//  incodi
//
//  Created by Yasin Kayhan on 8.08.2025.
//

import UIKit

protocol AlertPresenting {}

extension AlertPresenting where Self: UIViewController {
    func presentError(_ message: String, title: String = "Hata") {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(ac, animated: true)
    }
}
