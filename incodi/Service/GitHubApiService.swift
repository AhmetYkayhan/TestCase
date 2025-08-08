//
//  GitHubApiService.swift
//  incodi
//
//  Created by Yasin Kayhan on 7.08.2025.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case rateLimited(until: Date)
    case network(Error)
    case decoding(Error)
    case other(String)
}

protocol GitHubApiServiceProtocol {
    func searchUsers(query: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void)
}

final class GitHubApiService: GitHubApiServiceProtocol {
    private struct SearchResult: Decodable { let items: [GitHubUser] }
    
    func searchUsers(query: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        let url = "https://api.github.com/search/users"
        let params: Parameters = ["q": query]
        let headers: HTTPHeaders = [
            "Accept": "application/vnd.github+json",
            "User-Agent": "incodi-app"
        ]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .responseData { resp in
                let status = resp.response?.statusCode ?? -1
                
                if status == 403 {
                    var until: Date?
                    if let resetStr = (resp.response?.allHeaderFields["X-RateLimit-Reset"] as? String),
                       let epoch = TimeInterval(resetStr) {
                        until = Date(timeIntervalSince1970: epoch)
                    }
                    if until == nil, let data = resp.data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let reset = json["rate"] as? [String: Any],
                       let epoch = reset["reset"] as? TimeInterval {
                        until = Date(timeIntervalSince1970: epoch)
                    }
                    completion(.failure(ApiError.rateLimited(until: until ?? Date().addingTimeInterval(60))))
                    return
                }
                
                switch resp.result {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(SearchResult.self, from: data)
                            completion(.success(decoded.items))
                        } catch {
                            completion(.failure(ApiError.decoding(error)))
                        }
                    case .failure(let afError):
                        completion(.failure(ApiError.network(afError)))
                }
            }
    }
}
