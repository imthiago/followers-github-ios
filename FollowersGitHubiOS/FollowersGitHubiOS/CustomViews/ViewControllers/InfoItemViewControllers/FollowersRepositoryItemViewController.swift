//
//  FollowersRepositoryItemViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

protocol FollowersRepositoryItemViewControllerDelegate: AnyObject {
    func didTapProfile(for user: User)
}

class FollowersRepositoryItemViewController: FollowersInfoItemViewController {

    // MARK: - Private properties
    private weak var delegate: FollowersRepositoryItemViewControllerDelegate?

    // MARK: - Initialization
    init(user: User, delegate: FollowersRepositoryItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Internal properties
    override func didTapActionButton() {
        delegate?.didTapProfile(for: user)
    }

    // MARK: - Private functions
    private func configure() {
        firstInfoItem.set(infoItemType: .repo, withCount: user.publicRepos)
        secondInfoItem.set(infoItemType: .gist, withCount: user.publicGists)
        actionButton.set(color: .systemTeal, title: "GitHub Profile", systemImageName: "person")
    }
}
