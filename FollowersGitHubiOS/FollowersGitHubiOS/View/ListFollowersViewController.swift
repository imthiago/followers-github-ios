//
//  ListFollowersViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class ListFollowersViewController: FollowerLoadingDataViewController {

    enum Section {
        case main
    }

    // MARK: - Private properties
    private var username: String
    private var followers: [Follower]           = []
    private var filteredFollowers: [Follower]   = []
    private var page                            = 1
    private var hasMoreFollowers                = true
    private var isSearching                     = false
    private var isLoadingMoreFollowers          = false
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var collectionView: UICollectionView!

    // MARK: - Initialization
    init(username: String) {
        self.username   = username
        super.init(nibName: nil, bundle: nil)
        title           = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        fetchFollowers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddButton))
    }

    // MARK: - Private functions
    private func fetchFollowers(username: String, page: Int) {
        showLoading()
        isLoadingMoreFollowers = true

        Task {
            do {
                let followers = try await NetworkService.shared.getFollowers(for: username, page: page)
                updateView(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let followersError = error as? FollowerErrors {
                    showFollowersAlert(title: "Bad struff happened",
                                       message: followersError.rawValue,
                                       buttonTitle: "OK")
                } else {
                    showDefaultFollowerError()
                }
                isLoadingMoreFollowers = false
                dismissLoadingView()
            }
        }
    }

    private func updateView(with followers: [Follower]) {
        if followers.count < 100 {
            hasMoreFollowers = false
        }

        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them :)"
            DispatchQueue.main.async {
                self.presentEmptyStateView(with: message, in: self.view)
            }
            return
        }
        updateData(on: self.followers)
    }

    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc private func didTapAddButton() {

    }
}

// MARK: - Viewcodable
extension ListFollowersViewController: ViewCodable {
    func buildHierarchy() {

    }

    func setupConstraints() {

    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController

        collectionView = .init(frame: view.bounds,
                               collectionViewLayout: FollowersUIHelper.createThreeColumnsFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowersCollectionViewCell.self,
                                forCellWithReuseIdentifier: FollowersCollectionViewCell.reuseID)

        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.reuseID, for: indexPath) as? FollowersCollectionViewCell else {
                return nil
            }
            cell.set(follower: follower)
            return cell
        })
    }
}

// MARK: - UICollectionViewDelegate
extension ListFollowersViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offSetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            fetchFollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray                 = isSearching ? filteredFollowers : followers
        let follower                    = activeArray[indexPath.item]

        let userInfoViewController      = UserInfoViewController()
        userInfoViewController.username = follower.login
        userInfoViewController.delegate = self
        let navigationController        = UINavigationController(rootViewController: userInfoViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ListFollowersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// MARK: - UserInfoViewControllerDelegate
extension ListFollowersViewController: UserInfoViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        fetchFollowers(username: username, page: page)
    }
}
