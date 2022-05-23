//
//  FollowersTabBarController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

final class FollowersTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor         = .systemCyan
        UITabBar.appearance().backgroundColor   = .systemBackground
        UINavigationBar.appearance().tintColor  = .systemCyan
        viewControllers = [makeSearchFollowerNavigationController(), makeFavoriteFollowersNavigationController()]
    }

    private func makeSearchFollowerNavigationController() -> UINavigationController {
        let searchFollowerViewController = SearchFollowerViewController()
        searchFollowerViewController.title = "Search Follower"
        searchFollowerViewController.tabBarItem = .init(title: "Search",
                                                        image: .init(systemName: "magnifyingglass.circle.fill"),
                                                        tag: 0)
        return .init(rootViewController: searchFollowerViewController)
    }

    private func makeFavoriteFollowersNavigationController() -> UINavigationController {
        let favoriteFollowersViewController = FavoriteFollowersListViewController()
        favoriteFollowersViewController.title = "Favorite Followers"
        favoriteFollowersViewController.tabBarItem = .init(title: "Favorites",
                                                           image: .init(systemName: "person.fill.checkmark"),
                                                           tag: 1)
        return .init(rootViewController: favoriteFollowersViewController)
    }
}
