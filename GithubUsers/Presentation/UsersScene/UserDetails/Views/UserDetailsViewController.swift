//
//  UserDetailsViewController.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import UIKit

class UserDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    private var viewModel: UserDetailsViewModel!
    private var repos: [UserRepoItemViewModel] = []
    
    static func create(with viewModel: UserDetailsViewModel) -> UserDetailsViewController {
        let view = UserDetailsViewController(nibName: "UserDetailsViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDIdLoad()
        tableView.delegate = self
        tableView.dataSource = self
        bind(to: viewModel)
    }

    private func bind(to viewModel: UserDetailsViewModel) {
        viewModel.repos.observe(on: self) { [weak self] repos in
            self?.repos = repos
            self?.tableView.reloadData()
        }
        viewModel.followingInfo.observe(on: self) { [unowned self] (following) in
            self.followingLabel.text = following
        }
        viewModel.image.observe(on: self) { [unowned self] (image) in
            if let image = image {
                self.imageView.image = UIImage(data: image)
            }
        }
        viewModel.followersInfo.observe(on: self) { [unowned self] (followers) in
            self.followersLabel.text = followers
        }
        viewModel.title.observe(on: self) { [unowned self] (title) in
            self.loginName.text = title
        }
        viewModel.error.observe(on: self) { [unowned self] (error) in
            if let err = error {
                self.showAlert(message: err)
            }
        }
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = repos[indexPath.row].title
        return cell
    }
}
