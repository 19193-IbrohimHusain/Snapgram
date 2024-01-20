//
//  FavoriteProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import UIKit
import RxSwift
import RxDataSources
import Lottie

class WishlistViewController: BaseViewController {

    @IBOutlet weak var favTable: UITableView!
    
    private var vm = WishlistViewModel()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<WishlistSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchFavProduct()
    }
    
    private func setup(){
        setupNavigationBar()
        setupErrorView()
        setupTable()
        setupDataSource()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.titleView = configureNavigationTitle(title: "Wishlist")
    }
    
    private func setupTable() {
        favTable.delegate = self
        favTable.registerCellWithNib(WishlistTableCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell: WishlistTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: item)
            return cell
        }, canEditRowAtIndexPath: { _,_ in
            return true
        })
    }
    
    private func bindData() {
        vm.favProduct.asObservable().map {
            $0.isEmpty ? self.showErrorView() : self.errorView.removeFromSuperview()
            return [WishlistSection(section: 0, items: $0)]
        }.bind(to: favTable.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
    
    private func showErrorView() {
        errorView.animationView.animation = LottieAnimation.named("wishlist_empty")
        errorView.animationView.play()
        errorView.titleLabel.text = "Got any wishlist?"
        errorView.descriptionLabel.text = "Let's find your favorite products!"
        errorView.navigateBtn.rx.tap.throttle(.seconds(3), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = TabBarViewController()
            vc.selectedIndex = 3
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.setViewControllers([vc], animated: true)
        }).disposed(by: bag)
        errorView.navigateBtn.isHidden = false
        favTable.addSubview(errorView)
    }
}

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in self.vm.deleteItems(indexPath: indexPath) }])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.sectionModels.first?.items[indexPath.row] else { return }
        let vc = DetailProductViewController()
        vc.id = Int(item.productID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
