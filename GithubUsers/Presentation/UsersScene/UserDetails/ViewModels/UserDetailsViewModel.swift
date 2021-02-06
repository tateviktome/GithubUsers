//
//  UserDetailsViewModel.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import Foundation

protocol UserDetailsViewModelInput {
    func viewDIdLoad()
}

protocol UserDetailsViewModelOutput {
    var title: Observable<String> { get }
    var image: Observable<Data?> { get }
    var overview: Observable<String> { get }
    var followersInfo: Observable<String> { get }
    var followingInfo: Observable<String> { get }
    var repos: Observable<[UserRepoItemViewModel]> { get }
    var error: Observable<String?> { get }
}

class UserDetailsViewModel {
    private let useCase: UserDetailsUseCase
    private let user: User
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    // MARK: - OUTPUT
    let title: Observable<String> = Observable("")
    let image: Observable<Data?> = Observable(nil)
    let overview: Observable<String> = Observable("")
    let followersInfo: Observable<String> = Observable("")
    let followingInfo: Observable<String> = Observable("")
    let repos: Observable<[UserRepoItemViewModel]> = Observable([UserRepoItemViewModel]())
    let error: Observable<String?> = Observable(nil)
    
    init(user: User, useCase: UserDetailsUseCase) {
        self.useCase = useCase
        self.user = user
        
        self.title.value = user.login ?? ""
        self.image.value = user.image
    }
    
    private func fetchFollowers(onComplete: @escaping (()->Void)) {
        let _ = useCase.fetchFollowers(for: user) { [weak self] (users) in
            self?.followersInfo.value = "\(users.first?.login ?? "") and \(users.count) others follow"
            onComplete()
        } completion: { [weak self] (result) in
            switch result {
            case .success(let users):
                self?.followersInfo.value = "\(users.first?.login ?? "") and \(users.count) others follow"
                onComplete()
            case .failure(let error):
                self?.error.value = error.localizedDescription
            }
        }
    }
    
    private func fetchFollowing(onComplete: @escaping (()->Void)) {
        let _ = useCase.fetchFollowing(for: user) { [weak self] (users) in
            self?.followingInfo.value = "\(users.first?.login ?? "") and \(users.count) others follow"
            onComplete()
        } completion: { [weak self] (result) in
            switch result {
            case .success(let users):
                self?.followingInfo.value = "\(users.first?.login ?? "") and \(users.count) others follow"
                onComplete()
            case .failure(let error):
                self?.error.value = error.localizedDescription
            }
        }
    }
    
    private func fetchRepos() {
        let _ = useCase.fetchRepos(for: user) { [weak self] (repos) in
            self?.repos.value = repos.map({ UserRepoItemViewModel(title: $0.name, description: $0.name) })
        } completion: { [weak self] (result) in
            switch result {
            case .success(let repos):
                self?.repos.value = repos.map({ UserRepoItemViewModel(title: $0.name, description: $0.name) })
            case .failure(let error):
                self?.error.value = error.localizedDescription
            }
        }
    }
}

extension UserDetailsViewModel: UserDetailsViewModelOutput, UserDetailsViewModelInput {
    func viewDIdLoad() {
      //could have done with dispatchgroups and do not wait for each others' completion, had a core data merge issue
        fetchFollowers { [weak self] in
            self?.fetchFollowing { [weak self] in
                self?.fetchRepos()
            }
        }
    }
}
