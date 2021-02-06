//
//  UsersViewModel.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import Foundation

struct UsersViewModelClosures {
    let showUserDetails: (User) -> Void
}

protocol UsersViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didSelect(item: UserItemViewModel)
    func itemWillAppear(item: UserItemViewModel)
}

protocol UsersViewModelOutput {
    var items: Observable<[UserItemViewModel]> { get }
    var query: Observable<String> { get }
    var error: Observable<String?> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

class UsersViewModel {
    private let usersUseCase: UsersUseCase?
    private let closures: UsersViewModelClosures?

    private var userLoadTask: Cancellable? { willSet { userLoadTask?.cancel() } }
    private let imagesRepository: ImagesRepository?
    
    // MARK: - OUTPUT
    let items: Observable<[UserItemViewModel]> = Observable([])
    let query: Observable<String> = Observable("")
    let error: Observable<String?> = Observable(nil)
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Users", comment: "")
    let emptyDataTitle = NSLocalizedString("Search users", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search users", comment: "")

    init(usersUseCase: UsersUseCase, imagesRepository: ImagesRepository,
         closures: UsersViewModelClosures? = nil) {
        self.usersUseCase = usersUseCase
        self.closures = closures
        self.imagesRepository = imagesRepository
    }
    
    private func load() {
        userLoadTask = usersUseCase?.fetch(cached: { [weak self] (users) in
            guard let self = self else { return }
            self.items.value = users.map({ UserItemViewModel(user: $0) }).sorted(by: { $0.user?.id ?? 0 < $1.user?.id ?? 0 })
        }, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.items.value = users.map({ UserItemViewModel(user: $0) }).sorted(by: { $0.user?.id ?? 0 < $1.user?.id ?? 0 })
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        })
    }
    
    private func fetchImage(user: User)
    {
        guard user.image == nil else { return }
        DispatchQueue.global(qos: .background).async {
            let _ = self.imagesRepository?.fetchImage(for: user, completion: { [weak self] (result) in
                switch result {
                case .success(let data):
                    let allUsers = self?.items.value ?? []
                    if let currentUser = allUsers.firstIndex(where: { $0.user?.id == user.id }) {
                        allUsers[currentUser].user?.image = data
                    }
                    self?.items.value = allUsers
                case .failure(let error):
                    self?.error.value = error.localizedDescription
                }
            })
        }
    }
}

extension UsersViewModel: UsersViewModelInput, UsersViewModelOutput {
    func viewDidLoad() {
        load()
    }
    
    func didSearch(query: String) {
        userLoadTask?.cancel()
        userLoadTask = usersUseCase?.search(query: UserQuery(query: query), completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.items.value = users.map({ UserItemViewModel(user: $0) }).sorted(by: { $0.user?.id ?? 0 < $1.user?.id ?? 0 })
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        })
    }
    
    func didSelect(item: UserItemViewModel) {
        if let user = item.user {
            closures?.showUserDetails(user)
        }
    }
    
    func itemWillAppear(item: UserItemViewModel) {
        if let user = item.user {
            fetchImage(user: user)
        }
    }
}
