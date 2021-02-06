//
//  UsersResponseStorage.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/4/21.
//

import Foundation
import CoreData

final class CoreDataUsersStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(user: UserDTO? = nil) -> NSFetchRequest<UserEntity> {
        let request: NSFetchRequest = UserEntity.fetchRequest()
        request.predicate = user != nil ? NSPredicate(format: "id=%d", argumentArray: [user?.id ?? 0]) : nil
        return request
    }

    private func deleteResponse(in context: NSManagedObjectContext) {
        let request = fetchRequest()
        do {
            try context.fetch(request).forEach { result in
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }

    private func deleteRepos(for user: UserDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest()
        do {
            if let result = try context.fetch(request).first(where: { $0.id == Int64(user.id ?? 0) }) {
                result.repos?.forEach({ context.delete($0 as! NSManagedObject) })
            }
        } catch {
            print(error)
        }
    }
    
    private func deleteFollowers(for user: UserDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest()
        do {
            if let result = try context.fetch(request).first(where: { $0.id == Int64(user.id ?? 0) }) {
                result.followers?.forEach({ context.delete($0 as! NSManagedObject) })
            }
        } catch {
            print(error)
        }
    }
    
    private func deleteFollowing(for user: UserDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest()
        do {
            if let result = try context.fetch(request).first(where: { $0.id == Int64(user.id ?? 0) }) {
                result.following?.forEach({ context.delete($0 as! NSManagedObject) })
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataUsersStorage: UsersResponseStorage {
    //MARK: -Get
    func getRepos(for user: UserDTO, completion: @escaping (Result<[UserRepoDTO]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = self.fetchRequest(user: user)
            
                let result = try context.fetch(request).first
                let repos = result?.repos?.allObjects.map({ ($0 as! UserRepoEntity).toDTO() })
                completion(.success(repos))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func getFollowers(for user: UserDTO, completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = self.fetchRequest(user: user)
            
                let result = try context.fetch(request).first
                let repos = result?.followers?.allObjects.map({ ($0 as! UserEntity).toDTO() })
                completion(.success(repos))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func getFollowing(for user: UserDTO, completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = self.fetchRequest(user: user)
            
                let result = try context.fetch(request).first
                let repos = result?.following?.allObjects.map({ ($0 as! UserEntity).toDTO() })
                completion(.success(repos))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func getResponse(completion: @escaping (Result<[UserDTO]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = self.fetchRequest()
            
            let result = try context.fetch(request)
                completion(.success(result.map({ $0.toDTO() })))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    //MARK: -Save
    func saveRepos(repos: [UserRepoDTO], for user: UserDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteRepos(for: user, in: context)
                var entities: [UserRepoEntity] = []
                for item in repos {
                    let itemm = item.toEntity(in: context)
                    entities.append(itemm)
                }
                let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "UserEntity")
                fetchRequest.predicate = NSPredicate(format: "id = %d", user.id!)
                let userr = try context.fetch(fetchRequest).first as? NSManagedObject
                userr?.setValue(NSSet(array: entities), forKey: "repos")
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func saveFollowers(followers: [UserDTO], for user: UserDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteFollowers(for: user, in: context)
                var entities: [UserEntity] = []
                for item in followers {
                    let itemm = item.toEntity(in: context)
                    entities.append(itemm)
                }
                let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "UserEntity")
                fetchRequest.predicate = NSPredicate(format: "id = %d", user.id!)
                let userr = try context.fetch(fetchRequest).first as? NSManagedObject
                userr?.setValue(NSSet(array: entities), forKey: "followers")
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func saveFollowing(following: [UserDTO], for user: UserDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteFollowing(for: user, in: context)
                var entities: [UserEntity] = []
                for item in following {
                    let itemm = item.toEntity(in: context)
                    entities.append(itemm)
                }
                let userr = try? context.fetch(self.fetchRequest()).first
                userr?.setValue(NSSet(array: entities), forKey: "following")
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func save(response: [UserDTO]) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(in: context)
                for item in response {
                    let _ = item.toEntity(in: context)
                }
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
