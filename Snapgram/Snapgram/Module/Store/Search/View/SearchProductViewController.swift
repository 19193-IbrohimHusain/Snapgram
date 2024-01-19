//
//  SearchProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 14/12/23.
//

import UIKit

class SearchProductViewController: BaseViewController {
    
    @IBOutlet weak var searchCollection: UICollectionView!
    
    private var vm = SearchProductViewModel()
    private var snapshot = NSDiffableDataSourceSnapshot<SectionSearchProduct, ProductModel>()
    private var dataSource: SearchCollectionDataSource!
    private var layout: UICollectionViewCompositionalLayout!
    private var searchBar = CustomSearchNavBar()
    private var product: [ProductModel]? {
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
        clearSnapshot()
        vm.setupSearch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearSnapshot()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupCollection()
        setupDataSource()
        setupCompositionalLayout()
        bindData()
        searchBar.observeTextChanges(querySubject: &vm.searchQuery, bag: bag)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationItem.backButtonTitle = nil
        self.navigationItem.titleView = searchBar
    }
    
    private func setupCollection() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        searchCollection.refreshControl = refreshControl
        searchCollection.delegate = self
        searchCollection.registerCellWithNib(FYPCollectionCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: searchCollection) { (collectionView, indexPath, product) in
            let cell:FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: product)
            return cell
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self else { fatalError("Invalid section index") }
            return NSCollectionLayoutSection.createFYPLayout(env: env, items: self.product ?? searchEntity, section: 0, sectionHorizontalSpacing: 20, leading: 20, trailing: 20, top: 20)
        })
        
        searchCollection.collectionViewLayout = layout
    }
    
    private func loadSnapshot() {
        guard let product = self.product else { return }
        
        if product.isEmpty {
            showErrorView()
        }
        
        snapshot.deleteAllItems()
        snapshot.deleteSections([.main])
        
        snapshot.appendSections([.main])
        snapshot.appendItems(product)
        
        searchCollection.hideSkeleton(reloadDataAfter: false)
        dataSource.apply(snapshot, animatingDifferences: true)
        self.product = nil
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] products in
            guard let self = self else { return }
                self.product = products
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }

            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.errorView.removeFromSuperview()
                self.searchCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.refreshControl.endRefreshing()
                self.searchCollection.hideSkeleton(reloadDataAfter: false)
            case .failed:
                self.searchCollection.hideSkeleton(reloadDataAfter: false)
                self.showErrorView(desc: "Please pull to refresh")
            }
        }).disposed(by: bag)
    }
    
    private func showErrorView(desc: String = "Apologies! There's no item with that name") {
        errorView.descriptionLabel.text = desc
        searchCollection.addSubview(errorView)
    }
    
    private func clearSnapshot() {
        product = nil
        snapshot.deleteAllItems()
        snapshot.deleteSections([.main])
        searchCollection.hideSkeleton(reloadDataAfter: false)
        dataSource.apply(snapshot)
        self.errorView.removeFromSuperview()
    }
    
    private func refreshData() {
        clearSnapshot()
        vm.setupSearch()
    }
}

extension SearchProductViewController: UICollectionViewDelegate {
    private func navigateToDetail(index: Int) {
        let productID = snapshot.itemIdentifiers[index].id
        let vc = DetailProductViewController()
        vc.id = productID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        navigateToDetail(index: index)
    }
}
