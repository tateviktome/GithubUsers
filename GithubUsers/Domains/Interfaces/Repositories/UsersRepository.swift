//
//  UsersRepository.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/3/21.
//

import Foundation

protocol UsersRepository {
    @discardableResult
    func fetchUsers(cached: @escaping ([User]) -> Void,
                    completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func searchUsers(query: UserQuery,
                     completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func getFollowers(for user: User, cached: @escaping ([User]) -> Void,
                      completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func getFollowing(for user: User, cached: @escaping ([User]) -> Void,
                      completion: @escaping (Result<[User], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func getRepos(for user: User, cached: @escaping ([Repo]) -> Void,
                      completion: @escaping (Result<[Repo], Error>) -> Void) -> Cancellable?
}

