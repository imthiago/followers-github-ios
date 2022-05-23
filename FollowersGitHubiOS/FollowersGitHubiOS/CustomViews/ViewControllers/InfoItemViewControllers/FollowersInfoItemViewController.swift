//
//  FollowersInfoItemViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

protocol InfoItemViewControllerDelegate: AnyObject {
    func didTapProfile(for user: User)
    func didTapFollowers(for user: User)
}

class FollowersInfoItemViewController: UIViewController {

    // MARK: - Private properties
    private let stackView = UIStackView()

    // MARK: - Internal properties
    let firstInfoItem = FollowersInfoItemView(frame: .zero)
    let secondInfoItem = FollowersInfoItemView(frame: .zero)
    let actionButton = FollowersButton(frame: .zero)
    let user: User

    // MARK: - Initialization
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
    }

    @objc func didTapActionButton() { }
}

// MARK: - Viewcodable
extension FollowersInfoItemViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubviews(stackView, actionButton)
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configureViews() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(firstInfoItem)
        stackView.addArrangedSubview(secondInfoItem)

        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
}
