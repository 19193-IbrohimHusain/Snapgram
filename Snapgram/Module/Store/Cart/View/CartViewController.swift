//
//  CartViewController.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

class CartViewController: BaseViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cartTable: UITableView!
    
    var vm = CartViewModel()
    var snapshot = NSDiffableDataSourceSnapshot<SectionCartTable, Cart>()
    var dataSource: UITableViewDiffableDataSource<SectionCartTable, Cart>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearSnapshot()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupTable()
        setupDataSource()
        bindData()
        btnEvent()
    }
    
    private func setupTable() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        cartTable.refreshControl = refreshControl
        cartTable.delegate = self
        cartTable.registerCellWithNib(CartTableCell.self)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.titleView = configureNavigationTitle(title: "Cart")
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(navigateToWishlist)), animated: true)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: cartTable) { [weak self] (tableView, indexPath, item) in
            guard let self = self else { return UITableViewCell() }
            let cell: CartTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.indexPath = indexPath
            if let data = self.dataSource.itemIdentifier(for: indexPath) {
                cell.configure(with: data)
            }
            return cell
        }
    }
    
    private func btnEvent() {
        buyBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.displayAlert(title: "Apologies!", message: "This feature is coming soon~")
        }).disposed(by: bag)
        
        selectAllBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.displayAlert(title: "Apologies!", message: "This feature is coming soon~")
        }).disposed(by: bag)
    }
    
    internal func addAlertAction() -> UIAlertAction {
        let navigateToCartAction = UIAlertAction(title: "See Wishlist", style: .default) { _ in
            let vc = WishlistViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return navigateToCartAction
    }
    
    private func refreshData() {
        self.errorView.removeFromSuperview()
        self.bgView.isHidden = false
        clearSnapshot()
        vm.fetchCartItems()
    }
    
    @objc private func navigateToWishlist() {
        let vc = WishlistViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailProductViewController()
        if let item = dataSource.itemIdentifier(for: indexPath) {
            vc.id = Int(item.productID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
