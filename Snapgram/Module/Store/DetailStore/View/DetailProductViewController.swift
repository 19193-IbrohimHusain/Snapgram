//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

class DetailProductViewController: BaseViewController {
    
    @IBOutlet weak var detailCollection: UICollectionView!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    internal let collections = SectionDetailProduct.allCases
    internal let vm = DetailProductViewModel()
    internal var id: Int?
    internal var currentIndex = 0
    internal var timer: Timer?
    internal var product: ProductModel?
    internal var image: [GalleryModel]?
    internal var recommendation: [ProductModel]?
    internal var isCart: Bool?
    internal var layout: UICollectionViewCompositionalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = id {
            vm.fetchDetailProduct(param: ProductParam(id: id, limit: nil))
            vm.fetchRecommendationProduct()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addToCartBtn.layer.cornerRadius = 8.0
    }
    
    private func setup() {
        setupNavigationBar()
        setupCollection()
        setupErrorView()
        setupCompositionalLayout()
        bindData()
        btnEvent()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.backButtonTitle = nil
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupCollection() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        detailCollection.refreshControl = refreshControl
        detailCollection.contentInsetAdjustmentBehavior = .never
        detailCollection.delegate = self
        detailCollection.dataSource = self
        collections.forEach {
            detailCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(in: detailCollection)
        }
    }
    
    private func btnEvent() {
        chatBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.displayAlert(title: "Apologies!", message: "This feature is coming soon~")
        }).disposed(by: bag)
        addToCartBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self, let product = self.product else { return }
            self.addLoading(self.addToCartBtn)
            self.isCart = true
            let state = self.vm.addItemToCoreData(for: .cart(id: product.id), product: product, image: self.image)
            self.resultHandler(for: state, destination: "Cart")
            self.afterDissmissed(self.addToCartBtn, title: "Add to cart")
        }).disposed(by: bag)
    }
    
    private func refreshData() {
        self.currentIndex = 0
        self.product = nil
        self.recommendation?.removeAll()
        vm.fetchRecommendationProduct()
        vm.fetchDetailProduct(param: ProductParam(id: id, limit: nil))
        self.errorView.removeFromSuperview()
    }
}

extension DetailProductViewController: UICollectionViewDelegate {
    private func navigateToDetail(index: Int) {
        if let productID = recommendation?[index].id {
            let vc = DetailProductViewController()
            vc.id = productID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 3 else { return }
        let index = indexPath.item
        navigateToDetail(index: index)
    }
}

extension DetailProductViewController: NameCellDelegate {
    func addFavorite() {
        if let product = self.product {
            self.isCart = false
            let state = vm.addItemToCoreData(for: .favorite(id: product.id), product: product, image: self.image)
            self.resultHandler(for: state, destination: "Wishlist")
            detailCollection.reloadData()
        }
    }
    
    func checkIsFavorite() -> Bool {
        return vm.isItemExist(product: self.product)
    }
}
