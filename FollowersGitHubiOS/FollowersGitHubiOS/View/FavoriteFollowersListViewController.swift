//
//  FavoriteFollowersListViewController.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import UIKit

class FavoriteFollowersListViewController: FollowerLoadingDataViewController {

    // MARK: - Private properties
    private let tableView               = UITableView()
    private var favorites: [Follower]   = []

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        hideKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteProfiles()
    }

    private func fetchFavoriteProfiles() {
        UserDefaultsService.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.updateTableView(with: favorites, self)
            case .failure(let error):
                self.showFollowersAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    private func updateTableView(with favorites: [Follower], _ self: FavoriteFollowersListViewController) {
        if favorites.isEmpty {
            presentEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

// MARK: - Viewcodable
extension FavoriteFollowersListViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(tableView)
    }

    func configureViews() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()

        tableView.register(FavoriteFollowersTableViewCell.self, forCellReuseIdentifier: FavoriteFollowersTableViewCell.reuseID)
    }

    func setupConstraints() { }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FavoriteFollowersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteFollowersTableViewCell.reuseID) as? FavoriteFollowersTableViewCell else {
            return .init(frame: .zero)
        }
        cell.set(favorite: favorites[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationViewController = ListFollowersViewController(username: favorite.login)

        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        UserDefaultsService.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let error = error else {
                self?.favorites.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self?.showFollowersAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
        }
    }
}
