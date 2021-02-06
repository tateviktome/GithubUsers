//
//  UserItemViewModel.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import Foundation
import UIKit

class UserItemViewModel {
    var userName: Observable<String> = Observable("")
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
}

extension UserItemViewModel {
    func viewDidLoad() {
        if let user = user {
            userName.value = user.login ?? ""
        }
    }
}
