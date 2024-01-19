import Foundation
import UIKit

extension UITableView {
    
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func registerCellWithNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: .main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
    
    func showLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
    func hideLoadingFooter() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
    
}
