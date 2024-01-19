//
//  ExtCart + BindData.swift
//  Snapgram
//
//  Created by Phincon on 04/01/24.
//

import Foundation
import Lottie
import RxSwift

extension CartViewController {
    internal func bindData() {
        vm.cartItems.asObservable().subscribe(onNext: { [weak self] items in
            guard let self = self, let items = items else { return }
            self.loadSnapshot(item: items)
        }).disposed(by: bag)
    }
    
    private func showErrorView() {
        errorView.animationView.animation = LottieAnimation.named("cart_empty")
        errorView.animationView.play()
        errorView.titleLabel.text = "Whoa, your cart is empty!"
        errorView.descriptionLabel.text = "Let's fill it with your dream products!"
        errorView.navigateBtn.rx.tap.throttle(.seconds(3), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = TabBarViewController()
            vc.selectedIndex = 3
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.setViewControllers([vc], animated: true)
        }).disposed(by: bag)
        errorView.navigateBtn.isHidden = false
        cartTable.addSubview(errorView)
    }
    
    private func loadSnapshot(item: [Cart]) {
        if item.isEmpty {
            self.showErrorView()
            self.bgView.isHidden = true
        }
        
        self.refreshControl.endRefreshing()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(item)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    internal func resultHandler(for state: CoreDataResult, destination: String, item: Cart) {
        switch state {
        case .added:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        case .failed:
            self.displayAlert(title: "Failed", message: "Failed To Add Item")
        case .deleted:
            self.displayAlert(title: "Success", message: "Item Deleted From \(destination)", action: destination == "Wishlist" ? self.addAlertAction : nil) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        case .updated:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        }
    }
    
    internal func clearSnapshot(completion: (() -> Void)? = nil) {
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: false) { completion?() }
    }
}
