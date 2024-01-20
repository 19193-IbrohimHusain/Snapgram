import UIKit

protocol CategoryCollectionCellDelegate {
    func onCategorySelected(index: Int)
}

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var categoryBtn: UIButton!
    
    var index: Int = Int()
    var delegate: CategoryCollectionCellDelegate?
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .separator
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBtn.tintColor = .separator
    }
    
    func configureCollection(_ categoryEntity: CategoryCollectionEntity) {
        categoryBtn.setImage(UIImage(systemName: categoryEntity.image), for: .normal)
    }
    
    @IBAction func onCategoryBtnTap() {
        self.delegate?.onCategorySelected(index: index)
    }
}
