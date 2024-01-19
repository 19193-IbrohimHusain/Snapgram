import UIKit
import RxSwift

class CustomSearchNavBar: UIView {
    
    internal let searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search"
        textField.autocapitalizationType = .none
        textField.isSkeletonable = true
        textField.isUserInteractionDisabledWhenSkeletonIsActive = true
        return textField
    }()
    
    private let leftView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bag = DisposeBag()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        backgroundColor = .systemBackground
        leftView.addSubview(imageView)
        imageView.center = CGPoint(x: 15, y: 15)
        searchField.leftView = leftView
        searchField.leftViewMode = .always
        addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            searchField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude),

            imageView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor)
        ])
        
        searchField.layer.cornerRadius = 8.0
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = UIColor.systemGray4.cgColor
        searchField.addTarget(self, action: #selector(inputTapTextArea), for: .editingDidBegin)
        searchField.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        searchField.addTarget(self, action: #selector(didEndEditing), for: .editingDidEndOnExit)
    }
    
    @objc private func inputTapTextArea() {
        searchField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func didEndEditing() {
        searchField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    internal func configure(placeholder: String) {
        searchField.text = placeholder
    }
    
    internal func observeTextChanges(querySubject: inout BehaviorSubject<String?>, bag: DisposeBag) {
        searchField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: querySubject)
            .disposed(by: bag)
    }
}
