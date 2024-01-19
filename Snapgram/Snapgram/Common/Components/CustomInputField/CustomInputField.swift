import UIKit

class CustomInputField: UIView {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    @IBAction private func inputTapTextArea() {
        textField.becomeFirstResponder()
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @IBAction private func didEndEditing() {
        textField.resignFirstResponder()
        textField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func setup(placeholder: String, errorText: String) {
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.shadowColor = UIColor.systemGray2.cgColor
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.5
        errorLabel.text = errorText
        errorLabel.isHidden = true
    }
    
}
