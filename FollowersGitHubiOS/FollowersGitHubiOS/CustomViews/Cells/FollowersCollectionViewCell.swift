//
//  FollowersCollectionViewCell.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FollowersCollectionViewCell: UICollectionViewCell {

    // MARK: - Static properties
    static let reuseID = "FollowerCell"

    // MARK: - Private properties
    private let avatarImageView = FollowersAvatarImageView(frame: .zero)
    private let usernameLabel   = FollowersTitleLabel(textAlignment: .center, fontSize: 16)

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Properties
    func set(follower: Follower) {
        avatarImageView.fetchImage(fromURL: follower.avatarUrl)
        usernameLabel.text = follower.login
    }
}

// MARK: - Viewcodable
extension FollowersCollectionViewCell: ViewCodable {
    func buildHierarchy() {
        addSubviews(avatarImageView, usernameLabel)
    }

    func setupConstraints() {
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
