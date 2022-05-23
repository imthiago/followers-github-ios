//
//  UIViewController+Followers.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit
import SafariServices

extension UIViewController {
    func hideKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    func showFollowersAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = FollowersAlertViewController(alertTitle: title,
                                                                   message: message,
                                                                   buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }

    func showDefaultFollowerError() {
        DispatchQueue.main.async {
            let alertViewController = FollowersAlertViewController(alertTitle: "Something went wrong",
                                                                   message: "We were unable to complete your" +
                                                                   "task at this time. Please try again.",
                                                                   buttonTitle: "Ok")
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }

    func showSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemCyan
        present(safariViewController, animated: true)
    }
}
