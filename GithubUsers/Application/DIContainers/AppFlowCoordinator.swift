//
//  AppFlowCoordinator.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/3/21.
//

import Foundation
import UIKit

class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        self.showUsers()
    }
    
    func showUsers() {
        let usersSceneDIContainer = appDIContainer.makeUsersSceneDIContainer()
        let flow = usersSceneDIContainer.makeUsersFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
