//
//  FollowerLoadingDataViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FollowerLoadingDataViewController: UIViewController {

    // MARK: - Internal properties
    var containerView: UIView?

    // MARK: - Internal functions
    func presentLoading() {
        guard var containerView = containerView else { return }
        containerView = UIView(frame: view.bounds)
        view.addSubviews(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.25) {
            self.containerView?.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubviews(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }

    func presentEmptyStateView(with message: String, in view: UIView) {
        let followerEmptyStateView = FollowersEmptyStateView(message: message)
        followerEmptyStateView.frame = view.bounds
        view.addSubviews(followerEmptyStateView)
    }
}
