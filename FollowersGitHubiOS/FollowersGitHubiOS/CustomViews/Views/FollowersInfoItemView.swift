//
//  FollowersInfoItemView.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

enum InfoItemType {
    case repo, gist, followers, following
}

class FollowersInfoItemView: UIView {

    // MARK: - Private properties
    private let symbolImageView = UIImageView()
    private let titleLabel      = FollowersTitleLabel(textAlignment: .left, fontSize: 14)
    private let countLabel      = FollowersTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal functions
    func set(infoItemType: InfoItemType, withCount count: Int) {
        switch infoItemType {
        case .repo:
            symbolImageView.image   = SFSymbols.repos
            titleLabel.text         = "Public Repositories"
        case .gist:
            symbolImageView.image   = SFSymbols.gists
            titleLabel.text         = "Public Gists"
        case .followers:
            symbolImageView.image   = SFSymbols.followers
            titleLabel.text         = "Followers"
        case .following:
            symbolImageView.image   = SFSymbols.following
            titleLabel.text         = "Following"
        }
        countLabel.text             = String(count)
    }
}

// MARK: - Viewcodable
extension FollowersInfoItemView: ViewCodable {
    func buildHierarchy() {
        addSubviews(symbolImageView, titleLabel, countLabel)
    }

    func setupConstraints() {
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])

        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func configureViews() {
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
    }
}
