//
//  FavoriteFollowersListViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FavoriteFollowersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        hideKeyboardOnTap()
    }
}

// MARK: - Viewcodable
extension FavoriteFollowersListViewController: ViewCodable {
    func buildHierarchy() {

    }

    func setupConstraints() {

    }

    func configureViews() {
        view.backgroundColor = .systemBackground
    }
}
