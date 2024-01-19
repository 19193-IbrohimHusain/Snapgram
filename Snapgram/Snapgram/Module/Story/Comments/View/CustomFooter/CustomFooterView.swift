
import UIKit

class CustomFooterView: UITableViewHeaderFooterView {
    
    var footerTapped: (() -> Void)?

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 10)
        label.textColor = .gray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        // Customize appearance and add UI elements to the view
        contentView.backgroundColor = .white
        contentView.addSubview(label)
        
        // Add constraints for the label (adjust as needed)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupGesture() {
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        // Perform action when footer is tapped
        footerTapped?()
    }
    
    
    func configure(with text: String) {
        // Configure UI elements with data
        label.text = text
    }
}
