//
//  FollowersAvatarImageView.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FollowersAvatarImageView: UIImageView {

    // MARK: - Private properties
    let cache               = NetworkService.shared.cache
    let placeholderImage    = Images.placeholder

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal functions
    func fetchImage(fromURL url: String) {
        Task {
            image = await NetworkService.shared.downloadImage(from: url) ?? placeholderImage
        }
    }

    // MARK: - Private functions
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
    }
}
