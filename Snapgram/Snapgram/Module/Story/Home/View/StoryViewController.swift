import UIKit
import SkeletonView

class StoryViewController: BaseBottomSheetController {
    
    @IBOutlet internal weak var storyTable: UITableView!
    
    internal let tables = SectionStoryTable.allCases
    internal var vm = StoryViewModel()
    internal var isLoadMoreData = false
    internal var listStory = [ListStory]()
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.errorView.removeFromSuperview()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupTable()
        bindData()
        setupCommentPanel()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: configureNavigationTitle(title: "Snapgram")), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navigateToSearch)), animated: true)
    }
    
    private func setupTable() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        storyTable.refreshControl = refreshControl
        storyTable.delegate = self
        storyTable.dataSource = self
        tables.forEach { storyTable.registerCellWithNib($0.cellTypes) }
    }
    
    private func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    internal func loadMoreData() {
        page += 1
        isLoadMoreData = true
        vm.fetchStory(param: StoryParam(page: page, location: 0))
        storyTable.hideSkeleton()
        isLoadMoreData = false
    }
    
    private func refreshData() {
        self.page = 1
        self.isLoadMoreData = false
        self.listStory.removeAll()
        vm.fetchStory(param: StoryParam(page: 1))
        self.refreshControl.endRefreshing()
        self.errorView.removeFromSuperview()
    }
    
    @objc private func navigateToSearch() {
        let vc = SearchUserViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadMoreData == false else { return }
        switch SectionStoryTable(rawValue: indexPath.section) {
        case .feed:
            let total = listStory.count
            if indexPath.row == total - 1 {
                loadMoreData()
            }
        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}
