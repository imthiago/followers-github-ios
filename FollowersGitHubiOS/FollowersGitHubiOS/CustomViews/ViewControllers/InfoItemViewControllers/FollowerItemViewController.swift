//
//  FollowerItemViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

protocol FollowerItemViewControllerDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class FollowerItemViewController: FollowersInfoItemViewController {

    // MARK: - Private properties
    private weak var delegate: FollowerItemViewControllerDelegate?

    // MARK: - Initialization
    init(user: User, delegate: FollowerItemViewControllerDelegate) {
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
        delegate?.didTapGetFollowers(for: user)
    }

    // MARK: - Private properties
    private func configure() {
        firstInfoItem.set(infoItemType: .followers, withCount: user.followers)
        secondInfoItem.set(infoItemType: .following, withCount: user.following)
        actionButton.set(color: .systemGray, title: "Get Followers", systemImageName: "person.3")
    }
}
