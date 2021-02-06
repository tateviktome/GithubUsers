//
//  APIEndpoints.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import Foundation

struct APIEndpoints {
    
    static func getUsers() -> Endpoint<[UserDTO]> {

        return Endpoint(path: "https://api.github.com/users",
                        isFullPath: true,
                        method: .get)
    }

    static func searchUser(with requestDTO: UsersRequestDTO) -> Endpoint<[UserDTO]> {

        return Endpoint(path: "https://api.github.com/search/users",
                        isFullPath: true,
                        method: .get,
                        queryParametersEncodable: requestDTO,
                        keyPath: "items")
    }
    
    static func getFollowers(for user: User) -> Endpoint<[UserDTO]> {

        return Endpoint(path: user.followersURL ?? "",
                        isFullPath: true,
                        method: .get)
    }
    
    static func getFollowing(for user: User) -> Endpoint<[UserDTO]> {

        return Endpoint(path: "https://api.github.com/users/\(user.login ?? "")/following",
                        isFullPath: true,
                        method: .get)
    }
    
    static func getRepos(for user: User) -> Endpoint<[UserRepoDTO]> {

        return Endpoint(path: user.reposURL ?? "",
                        isFullPath: true,
                        method: .get)
    }
    
    static func getImage(for user: User) -> Endpoint<Data> {

        return Endpoint(path: user.avatarURL ?? "",
                        isFullPath: true,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
