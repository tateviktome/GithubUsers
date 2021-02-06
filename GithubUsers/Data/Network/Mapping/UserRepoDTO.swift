//
//  UserRepoDTO.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/6/21.
//

import Foundation
import CoreData

// MARK: - Data Transfer Object
struct UserRepoDTO: Decodable {
    var id: Int?
    var name: String?
    var description: String?
}

//MARK: - Domain To Mapping
extension Repo {
    func toDTO() -> UserRepoDTO {
        return .init(id: id, name: name, description: description)
    }
}

// MARK: - Mappings to Domain
extension UserRepoDTO {
    func mapToDomain() -> Repo {
        return .init(id: id,
                     name: name,
                     description: description)
    }
}

//MARK: - Mapping to Entity
extension UserRepoDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserRepoEntity {
        let entity: UserRepoEntity = .init(context: context)
        entity.id = Int64(id!)
        entity.name = name
        entity.descriptionn = description
        return entity
    }
}

//MARK: - Mapping to Data Transfer Object
extension UserRepoEntity {
    func toDTO() -> UserRepoDTO {
        return .init(id: Int(id),
                     name: name,
                     description: descriptionn)
    }
}
