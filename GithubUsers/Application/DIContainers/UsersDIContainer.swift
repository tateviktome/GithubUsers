//
//  UsersDIContainer.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/3/21.
//

import Foundation
import UIKit

final class UsersSceneDIContainer: UsersFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Persistent Storage
    lazy var usersStorage: UsersResponseStorage = CoreDataUsersStorage()
    
    // MARK: - Use Cases
    func makeUsersUseCase() -> UsersUseCase {
        return DefaultUsersUseCase(usersRepository: makeUsersRepository())
    }
    
    func makeUserDetailsUseCase() -> UserDetailsUseCase {
        return DefaultUserDetailsUseCase(usersRepository: makeUsersRepository())
    }
    
    // MARK: - Repositories
    func makeUsersRepository() -> UsersRepository {
        return DefaultUsersRepository(dataTransferService: dependencies.apiDataTransferService, cache: usersStorage)
    }

    func makeImagesRepository() -> ImagesRepository {
        return DefaultImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    // MARK: - Users
    func makeUsersViewController(closures: UsersViewModelClosures) -> UsersViewController {
        return UsersViewController.create(with: makeUsersViewModel(closures: closures))
    }
    
    func makeUsersViewModel(closures: UsersViewModelClosures) -> UsersViewModel {
        return UsersViewModel(usersUseCase: makeUsersUseCase(),
                              imagesRepository: makeImagesRepository(),
                                          closures: closures)
    }
    
    // MARK: - User Details
    func makeUserDetailsViewController(user: User) -> UserDetailsViewController {
        return UserDetailsViewController.create(with: makeUserDetailsViewModel(user: user))
    }

    func makeUserDetailsViewModel(user: User) -> UserDetailsViewModel {
        return UserDetailsViewModel(user: user, useCase: makeUserDetailsUseCase())
    }

    // MARK: - Flow Coordinators
    func makeUsersFlowCoordinator(navigationController: UINavigationController) -> UsersFlowCoordinator {
        return UsersFlowCoordinator(navigationController: navigationController,
                                    dependencies: self)
    }
}
