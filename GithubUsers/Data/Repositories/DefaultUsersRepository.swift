//
//  DefaultUsersRepository.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/4/21.
//

import Foundation

final class DefaultUsersRepository {

    private let dataTransferService: DataTransferService
    private let cache: UsersResponseStorage

    init(dataTransferService: DataTransferService, cache: UsersResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultUsersRepository: UsersRepository {

    func fetchUsers(cached: @escaping ([User]) -> Void, completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        cache.getResponse { (result) in
            if case let .success(userDTOs?) = result {
                cached(userDTOs.map({ $0.mapToDomain() }))
            }
            
            let endpoint = APIEndpoints.getUsers()
            task.networkTask = self.dataTransferService.request(with: endpoint) { response in
                switch response {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO)
                    completion(.success(responseDTO.map({ $0.mapToDomain() })))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    func searchUsers(query: UserQuery, completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.searchUser(with: query.toDTO())

        task.networkTask = self.dataTransferService.request(with: endpoint) { response in
            switch response {
            case .success(let responseDTO):
                self.cache.save(response: responseDTO)
                completion(.success(responseDTO.map({ $0.mapToDomain() })))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    func getFollowers(for user: User, cached: @escaping ([User]) -> Void, completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        cache.getFollowers(for: user.toDTO()) { (result) in
            if case let .success(userDTOs?) = result {
                cached(userDTOs.map({ $0.mapToDomain() }))
            }
            
            let endpoint = APIEndpoints.getFollowers(for: user)
            task.networkTask = self.dataTransferService.request(with: endpoint) { response in
                switch response {
                case .success(let responseDTO):
                    self.cache.saveFollowers(followers: responseDTO, for: user.toDTO())
                    completion(.success(responseDTO.map({ $0.mapToDomain() })))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    func getFollowing(for user: User, cached: @escaping ([User]) -> Void, completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        cache.getFollowing(for: user.toDTO()) { (result) in
            if case let .success(userDTOs?) = result {
                cached(userDTOs.map({ $0.mapToDomain() }))
            }
            
            let endpoint = APIEndpoints.getFollowing(for: user)
            task.networkTask = self.dataTransferService.request(with: endpoint) { response in
                switch response {
                case .success(let responseDTO):
                    self.cache.saveFollowing(following: responseDTO, for: user.toDTO())
                    completion(.success(responseDTO.map({ $0.mapToDomain() })))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    func getRepos(for user: User, cached: @escaping ([Repo]) -> Void, completion: @escaping (Result<[Repo], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        cache.getRepos(for: user.toDTO()) { (result) in
            if case let .success(userDTOs?) = result {
                cached(userDTOs.map({ $0.mapToDomain() }))
            }
            
            let endpoint = APIEndpoints.getRepos(for: user)
            task.networkTask = self.dataTransferService.request(with: endpoint) { response in
                switch response {
                case .success(let responseDTO):
                    self.cache.saveRepos(repos: responseDTO, for: user.toDTO())
                    completion(.success(responseDTO.map({ $0.mapToDomain() })))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
