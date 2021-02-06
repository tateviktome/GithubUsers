//
//  RepositoryTask.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/6/21.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
