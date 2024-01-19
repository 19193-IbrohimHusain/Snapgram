import UIKit
import RxSwift
import SkeletonView

class ProfileViewController: BaseBottomSheetController {
    
    @IBOutlet internal weak var profileTable: UITableView!
    
    internal let tables = SectionProfileTable.allCases
    private let vm = ProfileViewModel()
    private var currentUser: User?
    private var taggedPost: [ListStory]?
    private var userPost: [ListStory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.errorView.removeFromSuperview()
    }
    
    private func setup() {
        setupNavigationBar(title: "Profile", image1: "line.horizontal.3", image2: "plus.app", action1: #selector(showSettings), action2: #selector(addStory))
        setupErrorView()
        setupTable()
        bindData()
        setupBottomSheet(contentVC: SettingsViewController(), floatingPanelDelegate: self)
    }
    
    private func setupTable() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        profileTable.refreshControl = refreshControl
        profileTable.delegate =  self
        profileTable.dataSource =  self
        tables.forEach { profileTable.registerCellWithNib($0.cellTypes) }
    }
    
    private func bindData() {
        vm.userPost.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let validData = data else { return }
            self.userPost = validData
            DispatchQueue.main.async {
                self.profileTable.reloadData()
            }
        }).disposed(by: bag)
        
        vm.taggedPost.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let validData = data else { return }
            self.taggedPost = validData
        }).disposed(by: bag)
        
        vm.currentUser.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self, let user = user else { return }
            self.currentUser = user
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.profileTable.showAnimatedGradientSkeleton()
            case .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.profileTable.hideSkeleton()
                }
            case .failed:
                DispatchQueue.main.async {
                    self.profileTable.hideSkeleton()
                    self.profileTable.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
    
    internal func scrollToMenuIndex(sectionIndex: Int) {
        let index = IndexPath(row: 0, section: 2)
        if let cell = profileTable.cellForRow(at: index) as? PostTableCell {
            let indexPath = IndexPath(item: 0, section: sectionIndex)
            cell.postCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if indexPath.section == 0 {
                cell.invalidateIntrinsicContentSize()
                cell.postCollection.collectionViewLayout.invalidateLayout()
                cell.heightCollection.constant = cell.postHeight ?? 450
            } else if indexPath.section == 1 {
                cell.invalidateIntrinsicContentSize()
                cell.postCollection.collectionViewLayout.invalidateLayout()
                cell.heightCollection.constant = cell.tagHeight ?? 450
            }
        }
    }
    
    @objc private func addStory() {
        let vc = AddStoryViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func showSettings() {
        self.present(floatingPanel, animated: true)
    }
    
    private func refreshData() {
        userPost?.removeAll()
        taggedPost?.removeAll()
        vm.fetchStory(param: StoryParam(size: 1000))
        refreshControl.endRefreshing()
        profileTable.hideLoadingFooter()
        self.errorView.removeFromSuperview()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionProfileTable(rawValue: section)
        switch tableSection {
        case .profile, .category, .post:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = SectionProfileTable(rawValue: indexPath.section)
        switch table {
        case .profile:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileTableCell
            if let user = currentUser {
                cell.configure(with: user)
            }
            if let postCount = self.userPost?.count {
                cell.configureUserPost(count: postCount)
            }
            cell.delegate = self
            
            return cell
        case .category:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryTableCell
            cell1.delegate = self
            
            return cell1
        case .post:
            let cell2 = tableView.dequeueReusableCell(forIndexPath: indexPath) as PostTableCell
            cell2.delegate = self
            if let post = userPost, let tag = taggedPost {
                cell2.configure(post: post, tag: tag)
            }
            
            return cell2
        default: return UITableViewCell()
            
        }
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}
