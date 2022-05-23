//
//  ViewCodable.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import Foundation

protocol ViewCodable {
    func buildHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewCodable {
    func configureViews() { }

    func applyViewCode() {
        buildHierarchy()
        setupConstraints()
        configureViews()
    }
}
