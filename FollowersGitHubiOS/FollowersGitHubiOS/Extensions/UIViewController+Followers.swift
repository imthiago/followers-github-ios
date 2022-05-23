//
//  UIViewController+Followers.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
