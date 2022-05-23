//
//  SearchFollowerViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class SearchFollowerViewController: UIViewController {

    // MARK: - Private properties
    private let logoImageView       = UIImageView(frame: .zero)
    private let usernameTextField   = FollowersTextField(frame: .zero)
    private let searchButton        = FollowersButton(color: .systemGray,
                                                      title: "Search Followers",
                                                      systemImageName: "person.3")

    // MARK: - Computed properties
    private var enteredUsername: Bool {
        guard let text = usernameTextField.text else { return false }
        return !text.isEmpty
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        hideKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Private functions
    @objc private func fetchFollowers() {
        guard enteredUsername else {
            showFollowersAlert(title: "Empty Username",
                               message: "Please enter a username. We need to know who to look for.",
                               buttonTitle: "OK")
            return
        }
        usernameTextField.resignFirstResponder()
        let listFollowers = ListFollowersViewController()
        navigationController?.pushViewController(listFollowers, animated: true)
    }
}

// MARK: - Viewcodable
extension SearchFollowerViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubviews(logoImageView, usernameTextField, searchButton)
    }

    func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        logoImageView.image = Images.ghLogo
        usernameTextField.autocapitalizationType = .none
        usernameTextField.delegate = self
        searchButton.addTarget(self, action: #selector(fetchFollowers), for: .touchUpInside)
    }
}

// MARK: - UITextFieldDelegate
extension SearchFollowerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchFollowers()
        return true
    }
}
