import UIKit

@IBDesignable
class CustomButton: UIView {
    
    @IBOutlet weak var customButton: UIButton!
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .systemBackground
        self.addSubview(view)
    }
    
    @IBAction func onTap() {
        customButton.becomeFirstResponder()
        customButton.isEnabled = false
        customButton.isUserInteractionEnabled = false
        customButton.setTitle("", for: .disabled)
        customButton.setImage(UIImage(systemName: ""), for: .disabled)
    }
    
    func setup(title: String, image: String?) {
        customButton.setTitle(title, for: .normal)
        customButton.setImage(UIImage(systemName: image ?? ""), for: .normal)
        customButton.setAnimateBounce()
        customButton.layer.cornerRadius = 8.0
        customButton.layer.shadowColor = UIColor.gray.cgColor
        customButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        customButton.layer.shadowRadius = 3.0
        customButton.layer.shadowOpacity = 0.5
        customButton.layer.borderColor = UIColor.systemBlue.cgColor
        customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        customButton.setTitleColor(UIColor.white, for: .normal)
        customButton.configuration?.imagePadding = 4.0
        customButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
    }
}
