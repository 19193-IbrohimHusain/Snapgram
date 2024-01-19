import UIKit
import Lottie

class RegisterViewController: BaseViewController {

    @IBOutlet weak var registerAnimation: LottieAnimationView!
    @IBOutlet weak var nameInputField: CustomInputField!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var confirmPasswordInputField: CustomInputField!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    internal let vm = RegisterViewModel()
    internal var registerResponse: RegisterResponse?
    private let showPasswordImage = UIImageView(image: UIImage(systemName: "eye.fill"))
    private let showCPasswordImage = UIImageView(image: UIImage(systemName: "eye.fill"))
    private let rightPasswordView = UIView()
    private let rightCPasswordView = UIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegister()
    }
    
    
    private func setupRegister() {
        configureRegisterAnimation()
        configureImage()
        configureTextField()
        configureButton()
        bindData()
    }
    
    private func configureRegisterAnimation() {
        registerAnimation.loopMode = .loop
        registerAnimation.contentMode = .scaleAspectFill
        registerAnimation.play()
    }
    
    private func configureImage() {
        configureShowPassword(rightPasswordView, image: showPasswordImage, action: #selector(showPassword(_:)))
        configureShowPassword(rightCPasswordView, image: showCPasswordImage, action: #selector(showConfirmPassword(_:)))
    }

    private func configureShowPassword(_ containerView: UIView, image: UIImageView, action: Selector) {
        containerView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        containerView.addSubview(image)
        image.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        image.addGestureRecognizer(tapGesture)
    }

    private func configureTextField() {
        configureInputField(nameInputField, placeholder: "Name", errorText: "")
        configureInputField(emailInputField, placeholder: "Email", errorText: "Your email format is not valid")
        configurePasswordInputField(passwordInputField, placeholder: "Password", errorText: "Password must be at least 8 characters")
        configureCPasswordInputField(confirmPasswordInputField, placeholder: "Confirm Password", errorText: "The password is not the same as the one entered")
    }

    private func configureInputField(_ inputField: CustomInputField, placeholder: String, errorText: String) {
        inputField.setup(placeholder: placeholder, errorText: errorText)
    }

    private func configurePasswordInputField(_ passwordField: CustomInputField, placeholder: String, errorText: String) {
        configureInputField(passwordField, placeholder: placeholder, errorText: errorText)
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.rightView = rightPasswordView
        passwordField.textField.rightViewMode = .always
    }
    
    private func configureCPasswordInputField(_ passwordField: CustomInputField, placeholder: String, errorText: String) {
        configureInputField(passwordField, placeholder: placeholder, errorText: errorText)
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.rightView = rightCPasswordView
        passwordField.textField.rightViewMode = .always
    }

    private func configureButton() {
        signUpBtn.setup(title: "Sign Up", image: "")
        signInBtn.setAnimateBounce()
        actionSignUp()
    }

    @objc private func showPassword(_ sender: UITapGestureRecognizer) {
        togglePasswordVisibility(for: passwordInputField, imageView: showPasswordImage)
    }

    @objc private func showConfirmPassword(_ sender: UITapGestureRecognizer) {
        togglePasswordVisibility(for: confirmPasswordInputField, imageView: showCPasswordImage)
    }

    private func togglePasswordVisibility(for passwordField: CustomInputField, imageView: UIImageView) {
        passwordField.textField.isSecureTextEntry.toggle()
        imageView.image = UIImage(systemName: passwordField.textField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
    }
    
    @IBAction private func onSignInBtnTap() {
        navigateToLoginView()
    }
}
