//
//  SearchFollowerViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class SearchFollowerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        hideKeyboardOnTap()
    }
}

// MARK: - Viewcodable
extension SearchFollowerViewController: ViewCodable {
    func buildHierarchy() {

    }

    func setupConstraints() {

    }

    func configureViews() {
        view.backgroundColor = .systemBackground
    }
}
