//
//  UsersViewController.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/5/21.
//

import UIKit

final class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    
    private var viewModel: UsersViewModel!
    private var items: [UserItemViewModel] = []
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func create(with viewModel: UsersViewModel) -> UsersViewController {
        let view = UsersViewController(nibName: "UsersViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        setupSearchController()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "default")
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: UsersViewModel) {
        viewModel.items.observe(on: self) { [weak self] in
            self?.items = $0
            self?.tableView.reloadData()
            
            self?.tableView.isHidden = self?.items.isEmpty == true
        }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchController(query: $0) }
        viewModel.error.observe(on: self) { [weak self] error in
            if let err = error {
                self?.showAlert(message: err)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func updateSearchController(query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        tableView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
}

// MARK: - Setup Search Controller

extension UsersViewController {
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}

// MARK: - Setup TableView Controller
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.set(userItemViewModel: items[indexPath.row])        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelect(item: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.itemWillAppear(item: items[indexPath.row])
    }
}
