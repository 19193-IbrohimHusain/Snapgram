//
//  ExtStore + BindData.swift
//  Snapgram
//
//  Created by Phincon on 15/12/23.
//

import Foundation

extension StoreViewController {
    internal func bindData() {
        bindProductData()
        bindSportShoesData()
        bindCategoryData()
        bindLoadingStateData()
    }
    
    private func bindProductData() {
        vm.productData
            .asObservable()
            .subscribe(onNext: { [weak self] product in
                guard let self = self, var dataProduct = product else { return }
                dataProduct.remove(at: 0)
                self.product = dataProduct
                self.fyp.append(contentsOf: dataProduct)
            })
            .disposed(by: bag)
    }
    
    private func bindSportShoesData() {
        vm.sportShoes
            .asObservable()
            .subscribe(onNext: { [weak self] product in
                guard let self = self, let dataProduct = product else { return }
                self.fyp.append(contentsOf: dataProduct)
                self.loadSnapshot()
                self.startTimer()
            })
            .disposed(by: bag)
    }
    
    private func bindCategoryData() {
        vm.categoryData
            .asObservable()
            .subscribe(onNext: { [weak self] category in
                guard let self = self, let dataCategory = category else { return }
                self.category = dataCategory.reversed()
            })
            .disposed(by: bag)
    }
    
    private func bindLoadingStateData() {
        vm.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .notLoad:
                    self.errorView.removeFromSuperview()
                case .loading:
                    self.storeCollection.showAnimatedGradientSkeleton()
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                case .finished:
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    self.refreshControl.endRefreshing()
                    self.storeCollection.hideSkeleton(reloadDataAfter: false)
                case .failed:
                    DispatchQueue.main.async {
                        self.storeCollection.hideSkeleton()
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                        self.refreshControl.endRefreshing()
                        self.storeCollection.addSubview(self.errorView)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    private func loadSnapshot() {
        // append sections to snapshot
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(collections)
        }

        // append item to snapshot
        if let product = product {
            // append item to section carousel
            let section1 = product.prefix(5).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .carousel
                return modifiedItem
            }
            snapshot.appendItems(section1, toSection: .carousel)
            
            // append item to section popular
            let section2 = product.prefix(9).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .popular
                return modifiedItem
            }
            snapshot.appendItems(section2, toSection: .popular)
            
            // append item to section fyp
            if var section3 = product.first {
                section3.cellTypes = .forYouProduct
                snapshot.appendItems([section3], toSection: .forYouProduct)
            }
        }
        // apply snapshot to datasource
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    internal func startTimer() {
        isCarouselSectionVisible = true
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        guard let isVisible = isCarouselSectionVisible, let product = product?.prefix(5), isVisible else { return }
        currentIndex =  (currentIndex + 1) % (product.count == 0 ? 1 : product.count)
        storeCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}
