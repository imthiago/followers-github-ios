//
//  NetworkService.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import Combine
import UIKit

protocol NetworkServiceProtocol {
    func fetchFollowers(for username: String, page: Int) -> AnyPublisher<[Follower], Error>
    func fetchUserInfo(for username: String) -> AnyPublisher<User, Error>
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    let cache = NSCache<NSString, UIImage>()
    private let baseURL         = "https://api.github.com/users/"

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
        return decoder
    }()

    init() { }

    func fetchFollowers(for username: String, page: Int) -> AnyPublisher<[Follower], Error> {
        if let url = URL(string: baseURL + "\(username)/followers?per_page=100&page=\(page)") {
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Follower].self, decoder: decoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: FollowerErrors.invalidUsername).eraseToAnyPublisher()
    }

    func fetchUserInfo(for username: String) -> AnyPublisher<User, Error> {
        if let url = URL(string: baseURL + "\(username)") {
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: User.self, decoder: decoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: FollowerErrors.invalidUsername).eraseToAnyPublisher()
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
