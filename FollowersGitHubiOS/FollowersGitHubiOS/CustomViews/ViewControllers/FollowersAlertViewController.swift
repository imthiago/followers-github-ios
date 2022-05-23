//
//  FollowersAlertViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

final class FollowersAlertViewController: UIViewController {

    // MARK: - Private Subviews
    private let containerView = FollowersAlertContainerView()
    private let titleLabel = FollowersTitleLabel(textAlignment: .center, fontSize: 20)
    private let messageLabel = FollowersBodyLabel(textAlignment: .center)
    private let actionButton = FollowersButton(color: .systemPink, title: "Ok", systemImageName: "checkmark.circle")

    // MARK: - Private properties
    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?

    // MARK: - Initialization
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = alertTitle
        self.message        = message
        self.buttonTitle    = buttonTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
    }
}

// MARK: Viewcodable
extension FollowersAlertViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(messageLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.75)

        titleLabel.text = alertTitle ?? ""

        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}
