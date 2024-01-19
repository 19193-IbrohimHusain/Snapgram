import UIKit

protocol CategoryTableCellDelegate {
    func setCurrentSection(index: Int)
}

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var delegate: CategoryTableCellDelegate?
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    let horizontalBarView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalBarView.removeFromSuperview()
        setupCollection()
    }
    
    func setupCollection() {
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(CategoryCollectionCell.self)
        setupHorizontalBar()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        categoryCollection.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        categoryCollection.collectionViewLayout = UICollectionViewCompositionalLayout(section: categoryLayout())
    }
    
    private func categoryLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireHeight(withWidth: .fractionalWidth(1/2))
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func setupHorizontalBar() {
        horizontalBarView.backgroundColor = .label
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}

extension CategoryTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCollectionCell
        let categoryEntity = categoryItem[indexPath.item]
        cell.configureCollection(categoryEntity)
        cell.delegate = self
        cell.index = indexPath.item
        
        return cell
    }
}

extension CategoryTableCell: CategoryCollectionCellDelegate {
    func onCategorySelected(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.categoryCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.delegate?.setCurrentSection(index: index)
    }
}

