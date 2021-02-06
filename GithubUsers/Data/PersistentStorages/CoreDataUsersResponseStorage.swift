//
//  CoreDataUsersResponseStorage.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/4/21.
//

import Foundation

protocol UsersResponseStorage {
    func getResponse(completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void)
    func save(response: [UserDTO])
    
    func getRepos(for user: UserDTO, completion: @escaping (Result<[UserRepoDTO]?, CoreDataStorageError>) -> Void)
    func getFollowers(for user: UserDTO, completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void)
    func getFollowing(for user: UserDTO, completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void)
    
    func saveRepos(repos: [UserRepoDTO], for user: UserDTO)
    func saveFollowers(followers: [UserDTO], for user: UserDTO)
    func saveFollowing(following: [UserDTO], for user: UserDTO)
}
