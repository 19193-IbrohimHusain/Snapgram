//
//  DetailUserViewController.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class DetailUserViewController: BaseViewController {

    @IBOutlet weak var detailUserCollection: UICollectionView!
    
    internal var vm = DetailUserViewModel()
    internal var collections = SectionDetailUser.allCases
    internal var snapshot = NSDiffableDataSourceSnapshot<SectionDetailUser, ListStory>()
    internal var dataSource: DetailUserDataSource!
    internal var layout: UICollectionViewCompositionalLayout!
    internal var detailUser: ListStory?
    internal var tagPost: [ListStory]?
    internal var userPost: [ListStory]?
    
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
        setupCollection()
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationItem.backButtonTitle = nil
        if let userName = detailUser?.name {
            self.navigationItem.titleView = configureNavigationTitle(title: userName)
        }
    }
    
    private func setupCollection() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        detailUserCollection.refreshControl = refreshControl
        collections.forEach {
            detailUserCollection.registerCellWithNib($0.cellTypes)
        }
        detailUserCollection.registerCellWithNib(UserPostCell.self)
        detailUserCollection.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionHeader, DetailUserPostHeaderCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: detailUserCollection) { [weak self] (collectionView, indexPath, user) in
            guard let self = self else { return UICollectionViewCell() }
            switch user.detailUserSection {
            case .profile:
                let cell: DetailUserProfileCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let userPost = self.userPost {
                    cell.configure(with: user, postCount: userPost.count)
                }
                return cell
            case .post:
                let cell2: DetailUserPostCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let user = self.userPost, let tag = self.tagPost {
                    cell2.delegate = self
                    cell2.bindData(userPost: user, tagPost: tag)
                }
                return cell2
            default: return UICollectionViewCell()
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header: DetailUserPostHeaderCell = collectionView.dequeueHeaderFooterCell(kind: kind, forIndexPath: indexPath)
            header.delegate = self
            
            return header
        }
    }
    
    private func clearSnapshot() {
        userPost = nil
        tagPost = nil
        snapshot.deleteAllItems()
        detailUserCollection.hideSkeleton(reloadDataAfter: false)
        dataSource.apply(snapshot)
        self.errorView.removeFromSuperview()
    }
    
    private func refreshData() {
        clearSnapshot()
        if let userName = detailUser?.name {
            vm.userName = userName
            vm.fetchAllPost(param: StoryParam(size: 1000))
        }
    }
}
