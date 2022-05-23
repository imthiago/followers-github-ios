//
//  NetworkService.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    let cache = NSCache<NSString, UIImage>()
    private let baseURL         = "https://api.github.com/users/"

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
        return decoder
    }()

    private init() { }

    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            throw FollowerErrors.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FollowerErrors.invalidResponse
        }

        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw FollowerErrors.invalidData
        }
    }

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {
            throw FollowerErrors.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FollowerErrors.invalidResponse
        }

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw FollowerErrors.invalidData
        }
    }

    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return image
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
