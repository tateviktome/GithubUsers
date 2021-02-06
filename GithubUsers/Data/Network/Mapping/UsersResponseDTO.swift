//
//  UsersResponseDTO.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/4/21.
//

import Foundation
import CoreData

// MARK: - Data Transfer Object
struct UserDTO: Decodable {
    var id: Int?
    var login: String?
    var avatarURL: String?
    var followersURL: String?
    var followingURL: String?
    var reposURL: String?
    
    var following: [UserDTO]?
    var followers: [UserDTO]?
    var repos: [UserRepoDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case reposURL = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        followersURL = try container.decode(String.self, forKey: .followersURL)
        followingURL = try container.decode(String.self, forKey: .followingURL)
        reposURL = try container.decode(String.self, forKey: .reposURL)
    }
    
    init(id: Int?,
         login: String?,
         avatarURL: String?,
         followersURL: String?,
         followingURL: String?,
         reposURL: String?,
         following: [UserDTO]?,
         followers: [UserDTO]?,
         repos: [UserRepoDTO]?) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.followersURL = followersURL
        self.followersURL = followingURL
        self.reposURL = reposURL
        self.followers = followers
        self.following = following
        self.repos = repos
    }
}

// MARK: - Mappings to Domain

extension UserDTO {
    func mapToDomain() -> User {
        return .init(id: id,
                     login: login,
                     avatarURL: avatarURL,
                     followersURL: followersURL,
                     followingURL: followingURL,
                     reposURL: reposURL)
    }
}

//MARK: - Domain To Mapping
extension User {
    func toDTO() -> UserDTO {
        return .init(id: id,
                     login: login,
                     avatarURL: avatarURL,
                     followersURL: followersURL,
                     followingURL: followingURL,
                     reposURL: reposURL,
                     following: following?.map({ $0.toDTO() }),
                     followers: followers?.map({ $0.toDTO() }),
                     repos: repos?.map({ $0.toDTO() }))
    }
}

//MARK: - Mapping to Entity
extension UserDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let entity: UserEntity = .init(context: context)
        entity.id = Int64(id!)
        entity.login = login
        entity.avatarURL = avatarURL
        entity.followersURL = followersURL
        entity.followingURL = followingURL
        entity.reposURL = reposURL
        entity.followers = NSSet(array: followers ?? [])
        entity.following = NSSet(array: following ?? [])
        entity.repos = NSSet(array: repos ?? [])
        return entity
    }
}

//MARK: - Mapping to Data Transfer Object
extension UserEntity {
    func toDTO() -> UserDTO {
        return .init(id: Int(id),
                     login: login,
                     avatarURL: avatarURL,
                     followersURL: followersURL,
                     followingURL: followingURL,
                     reposURL: reposURL,
                     following: (following?.allObjects as? [UserDTO]),
                     followers: (followers?.allObjects as? [UserDTO]),
                     repos: (repos?.allObjects as? [UserRepoDTO]))
    }
}


struct UsersRequestDTO: Encodable {
    let query: String
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
    }
}

extension UserQuery {
    func toDTO() -> UsersRequestDTO {
        let dto = UsersRequestDTO(query: query)
        return dto
    }
}
