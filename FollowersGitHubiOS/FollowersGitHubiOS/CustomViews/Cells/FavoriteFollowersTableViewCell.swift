//
//  FavoriteFollowersTableViewCell.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FavoriteFollowersTableViewCell: UITableViewCell {

    // MARK: - Static properties
    static let reuseID = "FavoriteFollowerCell"

    // MARK: - Private properties
    private let avatarImageView = FollowersAvatarImageView(frame: .zero)
    private let usernameLabel   = FollowersTitleLabel(textAlignment: .left, fontSize: 26)

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Properties
    func set(favorite: Follower) {
        avatarImageView.fetchImage(fromURL: favorite.avatarUrl)
        usernameLabel.text = favorite.login
    }
}

// MARK: - Viewcodable
extension FavoriteFollowersTableViewCell: ViewCodable {
    func buildHierarchy() {
        addSubviews(avatarImageView, usernameLabel)
    }

    func setupConstraints() {
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}
