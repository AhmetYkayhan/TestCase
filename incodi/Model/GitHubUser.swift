//
//  GitHubUser.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation

struct GitHubUser: Codable, Equatable {
    let id: Int?
    let login: String?
    let avatar_url: String?
    let html_url: String?
}
