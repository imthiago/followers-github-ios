//
//  UserInfoViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import Combine
import Resolver
import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoViewController: FollowerLoadingDataViewController {

    // MARK: - UI Elements
    private let scrollView          = UIScrollView()
    private let contentView         = UIView()
    private let headerView          = UIView()
    private let itemViewOne         = UIView()
    private let itemViewTwo         = UIView()
    private let dateLabel           = FollowersBodyLabel(textAlignment: .center)
    private var itemViews: [UIView] = []

    // MARK: - Private properties
    private var username: String
    private weak var delegate: UserInfoViewControllerDelegate!
    @Injected private var networkService: NetworkServiceProtocol

    // MARK: - Subscriptions
    private var fetchUserInfoSubscription: AnyCancellable?

    // MARK: - Initialization
    init(username: String, delegate: UserInfoViewControllerDelegate) {
        self.username = username
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        getUserInfo()
    }

    // MARK: - Action handlers
    @objc func dismissViewController() {
        dismiss(animated: true)
    }

    // MARK: - Private functions
    private func getUserInfo() {
        fetchUserInfoSubscription = networkService
            .fetchUserInfo(for: username)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showFollowersAlert(title: "Something went wrong",
                                             message: error.localizedDescription,
                                             buttonTitle: "OK")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] user in
                self?.configureUIElements(with: user)
            })
    }

    private func configureUIElements(with user: User) {
        add(childViewController: FollowersRepositoryItemViewController(user: user,
                                                                       delegate: self), to: self.itemViewOne)
        add(childViewController: FollowerItemViewController(user: user, delegate: self), to: self.itemViewTwo)
        add(childViewController: FollowerHeaderUserInfoViewController(user: user), to: self.headerView)
        dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }

    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
}

// MARK: - Viewcodable
extension UserInfoViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        itemViews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(dismissViewController))
        headerView.backgroundColor = .systemBackground
    }
}

// MARK: - FollowerItemViewControllerDelegate & FollowersRepositoryItemViewControllerDelegate
extension UserInfoViewController: FollowerItemViewControllerDelegate, FollowersRepositoryItemViewControllerDelegate {
    func didTapProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            showFollowersAlert(title: "Invalid URL",
                               message: "The url attached to this user is invalid.",
                               buttonTitle: "Ok")
            return
        }
        showSafariViewController(with: url)
    }

    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            showFollowersAlert(title: "No Followers",
                               message: "This user has no followers. What a shame 🙁.",
                               buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}
