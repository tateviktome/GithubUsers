//
//  ImageRepository.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/6/21.
//

import Foundation

protocol ImagesRepository {
    func fetchImage(for user: User, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
