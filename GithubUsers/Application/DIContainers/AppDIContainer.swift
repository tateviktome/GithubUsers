//
//  AppDIContainer.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import Foundation

final class AppDIContainer {
        
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: "http://google.com")!)
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeUsersSceneDIContainer() -> UsersSceneDIContainer {
        let dependencies = UsersSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, imageDataTransferService: apiDataTransferService)
        return UsersSceneDIContainer(dependencies: dependencies)
    }
}
