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
    let avatarURL: String?
    let htmlURL: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL   = "html_url"
    }
}
