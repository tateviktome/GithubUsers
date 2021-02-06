//
//  UserTableViewCell.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    func set(userItemViewModel: UserItemViewModel) {
        userItemViewModel.viewDidLoad()
        if let image = userItemViewModel.user?.image {
            self.imageView?.image = UIImage(data: image)
        }
        userItemViewModel.userName.observe(on: self) { [weak self] (userName) in
            self?.textLabel?.text = userName
        }
    }
}
