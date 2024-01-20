//
//  ExtStore.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import Foundation
import UIKit

extension StoreViewController {
    internal func dequeueCell(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath,
            product: ProductModel
        ) -> UICollectionViewCell {
            switch product.cellTypes {
            case .carousel:
                return carouselCell(for: collectionView, at: indexPath, product: product)
            case .popular:
                return popularCell(for: collectionView, at: indexPath, product: product)
            case .forYouProduct:
                return fypCell(for: collectionView, at: indexPath)
            default:
                return UICollectionViewCell()
            }
        }

        private func carouselCell(
            for collectionView: UICollectionView,
            at indexPath: IndexPath,
            product: ProductModel
        ) -> UICollectionViewCell {
            let cell: CarouselCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let item = dataSource.itemIdentifier(for: indexPath) {
                item.galleries?.forEach {
                    cell.configure(with: $0)
                    cell.isSkeletonable = true
                }
            }
            return cell
        }

        private func popularCell(
            for collectionView: UICollectionView,
            at indexPath: IndexPath,
            product: ProductModel
        ) -> UICollectionViewCell {
            let cell: PopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let item = dataSource.itemIdentifier(for: indexPath) {
                cell.configure(with: item)
                cell.isSkeletonable = true
            }
            return cell
        }

    private func fypCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            let cell: FYPCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bindData(data: fyp)
            cell.delegate = self
            return cell
        }

    internal func dequeueHeaderFooter(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath
        ) -> UICollectionReusableView {
            guard let section = SectionStoreCollection(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            switch section {
            case .carousel:
                return carouselFooter(for: collectionView, at: indexPath)
            case .popular:
                return kind == UICollectionView.elementKindSectionHeader
                    ? popularHeader(for: collectionView, at: indexPath)
                    : popularFooter(for: collectionView, at: indexPath)
            case .forYouProduct:
                return fypHeader(for: collectionView, at: indexPath)
            }
        }

    private func carouselFooter(
            for collectionView: UICollectionView,
            at indexPath: IndexPath
        ) -> CarouselFooter {
            let footer: CarouselFooter = collectionView.dequeueHeaderFooterCell(
                kind: UICollectionView.elementKindSectionFooter,
                forIndexPath: indexPath
            )
            footer.subscribeTo(subject: vm.pagingCarousel, for: collections[1].rawValue)
            currentIndex = footer.pageControl.currentPage
            return footer
        }

    private func popularHeader(
            for collectionView: UICollectionView,
            at indexPath: IndexPath
        ) -> PopularHeader {
            let header: PopularHeader = collectionView.dequeueHeaderFooterCell(
                kind: UICollectionView.elementKindSectionHeader,
                forIndexPath: indexPath
            )
            header.delegate = self
            return header
        }

    private func popularFooter(
            for collectionView: UICollectionView,
            at indexPath: IndexPath
        ) -> PopularFooter {
            let footer: PopularFooter = collectionView.dequeueHeaderFooterCell(
                kind: UICollectionView.elementKindSectionFooter,
                forIndexPath: indexPath
            )
            footer.subscribeTo(subject: vm.pagingPopular, for: collections[2].rawValue)
            return footer
        }

    private func fypHeader(
            for collectionView: UICollectionView,
            at indexPath: IndexPath
        ) -> FYPHeader {
            let header: FYPHeader = collectionView.dequeueHeaderFooterCell(
                kind: UICollectionView.elementKindSectionHeader,
                forIndexPath: indexPath
            )
            header.delegate = self
            headerFYP = header.headerCollection
            header.configure(data: self.category ?? categoryDummy)
            
            return header
        }
}
