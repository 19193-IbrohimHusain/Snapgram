//
//  SearchUserViewController.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class SearchUserViewController: BaseViewController {

    @IBOutlet weak var searchTable: UITableView!
    
    private var searchBar = CustomSearchNavBar()
    private var vm = SearchUserViewModel()
    private var snapshot = NSDiffableDataSourceSnapshot<SectionSearchUser, ListStory>()
    private var dataSource: SearchUserDataSource!
    private var listUser: [ListStory]? {
        didSet {
            self.loadSnapshot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupTable()
        setupDataSource()
        bindData()
        searchBar.observeTextChanges(querySubject: &vm.searchQuery, bag: bag)
        vm.beginSearch()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationItem.backButtonTitle = nil
        self.navigationItem.titleView = searchBar
    }
    
    private func setupTable() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        searchTable.refreshControl = refreshControl
        searchTable.delegate = self
        searchTable.registerCellWithNib(UserTableCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: searchTable) { (tableView, indexPath, user) in
            let cell: UserTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: user)
            return cell
        }
    }
    
    private func bindData() {
        vm.allData.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self, let listUser = user else { return }
            self.listUser = listUser
        }).disposed(by: bag)
        
        vm.searchResult.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self, let listUser = user else { return }
            self.errorView.removeFromSuperview()
            self.listUser = nil
            self.listUser = listUser
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.errorView.removeFromSuperview()
                self.searchTable.showAnimatedGradientSkeleton()
            case .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.searchTable.hideSkeleton(reloadDataAfter: false)
                }
            case .failed:
                DispatchQueue.main.async {
                    self.searchTable.hideSkeleton(reloadDataAfter: false)
                    self.showErrorView(desc: "Please pull to refresh")
                }
            }
        }).disposed(by: bag)
    }
    
    private func loadSnapshot() {
        guard let user = self.listUser else { return }
        
        if user.isEmpty {
            showErrorView()
        }
        
        snapshot.deleteAllItems()
        snapshot.deleteSections([.main])
        
        snapshot.appendSections([.main])
        snapshot.appendItems(user)
        
        DispatchQueue.main.async {
            self.searchTable.hideSkeleton(reloadDataAfter: false)
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
    
    private func showErrorView(desc: String = "Apologies! There's no item with that name") {
        errorView.descriptionLabel.text = desc
        searchTable.addSubview(errorView)
    }
    
    private func clearSnapshot() {
        listUser = nil
        snapshot.deleteAllItems()
        snapshot.deleteSections([.main])
        self.searchTable.hideSkeleton(reloadDataAfter: false)
        self.dataSource.apply(self.snapshot)
        self.errorView.removeFromSuperview()
        
    }
    
    private func refreshData() {
        clearSnapshot()
        vm.fetchAllData(param: StoryParam(size: 1000))
    }
}

extension SearchUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailUserViewController()
        vc.detailUser = listUser?[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
