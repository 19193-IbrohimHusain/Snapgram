import UIKit
import SkeletonView

protocol StoryTableCellDelegate {
    func navigateToDetail(id: String)
}

class StoryTableCell: UITableViewCell {

    @IBOutlet private weak var storyCollectionView: UICollectionView!
    
    internal var delegate: StoryTableCellDelegate?
    
    internal var data: [ListStory]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    private func setupCollection() {
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyCollectionView.registerCellWithNib(StoryCollectionCell.self)
    }
    
    internal func configure(with story : [ListStory]) {
        self.data = story
        self.storyCollectionView.reloadData()
    }
}

extension StoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validData = data {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as StoryCollectionCell
            let snapEntity = validData[indexPath.item]
            cell.configureCollection(with: snapEntity)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let storyID = data?[index].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
}

extension StoryTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: StoryCollectionCell.self)
    }
}
