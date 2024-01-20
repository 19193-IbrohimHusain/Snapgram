//
//  DetailUserPostCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import UIKit

protocol DetailUserPostCollectionCellDelegate {
    func navigateToDetail(id: String)
    func didScroll(scrollView: UIScrollView)
    func didEndDecelerating(scrollView: UIScrollView)
}
class DetailUserPostCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var detailPostCollection: UICollectionView!
    
    internal var delegate: DetailUserPostCollectionCellDelegate?
    
    private var snapshot = NSDiffableDataSourceSnapshot<SectionDetailUserPost, ListStory>()
    private var dataSource: DetailUserPostDataSource!
    private var layout: UICollectionViewCompositionalLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearSnapshot()
    }
    
    private func setup() {
        setupCollection()
        setupDataSource()
        setupCompositionalLayout()
    }
    
    private func setupCollection() {
        detailPostCollection.delegate = self
        detailPostCollection.registerCellWithNib(UserPostCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: detailPostCollection) { (collectionView, indexPath, post) in
            
            let cell: UserPostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: post)
            return cell
        }
    }
    
    private func setupCompositionalLayout() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionDetailUserPost(rawValue: sectionIndex) else { fatalError("Invalid section index") }
            let items1 = self.dataSource.snapshot(for: .post).items
            let items2 = self.dataSource.snapshot(for: .tag).items
            
            switch section {
            case .post:
                return self.createLayout(env: env, section: sectionIndex, items: items1)
            case .tag:
                return self.createLayout(env: env, section: sectionIndex, items: items2)
            }
            
        }, configuration: config)
        
        detailPostCollection.collectionViewLayout = layout
    }
    
    private func createLayout(env: NSCollectionLayoutEnvironment, section: Int, items: [ListStory]) -> NSCollectionLayoutSection {
        let layout = GridLayout.makeLayoutSection(
            config: .init(
                columnCount: 3,
                interItemSpacing: 1,
                sectionHorizontalSpacing: 0.0,
                itemCountProvider:  {
                    return items.count
                },
                itemHeightProvider: { index, itemWidth in
                    var itemHeight = CGFloat()
                    items.forEach { _ in
                        itemHeight = CGFloat(150)
                    }
                    return itemHeight
                }),
            enviroment: env, sectionIndex: section
        )
        
        layout.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return layout
    }
    
    internal func bindData(userPost: [ListStory], tagPost: [ListStory]) {
        loadSnapshot(userPost: userPost, tagPost: tagPost)
    }
    
    private func loadSnapshot(userPost: [ListStory], tagPost: [ListStory]) {
        snapshot.appendSections([.post, .tag])
        
        let section1 = userPost.map {
            var modifiedItem = $0
            modifiedItem.detailPostSection = .post
            return modifiedItem
        }
        snapshot.appendItems(section1, toSection: .post)
        
        let section2 = tagPost.map {
            var modifiedItem = $0
            modifiedItem.detailPostSection = .tag
            return modifiedItem
        }
        snapshot.appendItems(section2, toSection: .tag)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func clearSnapshot() {
        snapshot.deleteSections([.post, .tag])
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
    }
}

extension DetailUserPostCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SectionDetailUserPost(rawValue: indexPath.section) else { return }
        let item = self.snapshot.itemIdentifiers(inSection: section)
        let id = item[indexPath.item].id
        self.delegate?.navigateToDetail(id: id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.didEndDecelerating(scrollView: scrollView)
    }
}
