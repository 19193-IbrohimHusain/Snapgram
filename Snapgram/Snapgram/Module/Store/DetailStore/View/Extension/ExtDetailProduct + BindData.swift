//
//  ExtDetailProduct + BindData.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation

extension DetailProductViewController {
    internal func bindData() {
        vm.dataProduct.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, let dataProduct = product else { return }
            self.product = dataProduct
            self.image = dataProduct.galleries?.suffix(3)
            self.startTimer()
        }).disposed(by: bag)
        
        vm.recommendation.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, var dataProduct = product else { return }
            dataProduct.remove(at: 0)
            self.recommendation = dataProduct
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .notLoad:
                self.detailCollection.hideSkeleton()
                self.errorView.removeFromSuperview()
            case .loading:
                self.detailCollection.showAnimatedGradientSkeleton()
            case .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.detailCollection.hideSkeleton()
                    self.detailCollection.reloadData()
                }
            case .failed:
                self.refreshControl.endRefreshing()
                self.detailCollection.hideSkeleton()
                self.detailCollection.addSubview(self.errorView)
            }
        }).disposed(by: bag)
    }
    
    internal func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        guard let image = image else { return }
        currentIndex =  (currentIndex + 1) % (image.count == 0 ? 1 : image.count)
        detailCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}
