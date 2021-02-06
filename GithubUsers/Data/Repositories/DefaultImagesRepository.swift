//
//  DefaultImagesRepository.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/6/21.
//

import Foundation

final class DefaultImagesRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultImagesRepository: ImagesRepository {
    
    func fetchImage(for user: User, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getImage(for: user)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }

            if case .failure(let error) = result,
                case let DataTransferError.networkFailure(networkError) = error,
                networkError.isNotFoundError {
                DispatchQueue.main.async { completion(.failure(error)) }
            } else {
                DispatchQueue.main.async { completion(result) }
            }
        }
        return task
    }
}
