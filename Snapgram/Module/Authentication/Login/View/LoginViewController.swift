import UIKit
import Lottie

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var loginAnimation: LottieAnimationView!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var signInBtn: CustomButton!
    @IBOutlet weak var signInWithAppleBtn: CustomButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    internal var loginResponse: LoginResponse?
    internal let vm = LoginViewModel()
    private let rightView = UIView()
    private let imageView = UIImageView(image: UIImage(systemName: "eye.fill"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    private func setupLogin() {
        setNavigationBar()
        configureLoginAnimation()
        configureShowImage()
        configureTextField()
        configureButton()
        handleBtn()
        bindData()
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func configureLoginAnimation() {
        loginAnimation.play()
        loginAnimation.contentMode = .scaleAspectFill
        loginAnimation.loopMode = .loop
    }
    
    private func configureShowImage() {
        rightView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightView.addSubview(imageView)
        imageView.center = CGPoint(x: rightView.bounds.width / 2, y: rightView.bounds.height / 2)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPassword))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func configureTextField() {
        emailInputField.setup(placeholder: "Email", errorText: "Your email format is not valid")
        passwordInputField.setup(placeholder: "Password", errorText: "Password must be at least 8 characters")
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.rightView = rightView
        passwordInputField.textField.rightViewMode = .always
    }
    
    private func configureButton() {
        signInBtn.setup(title: "Sign In", image: "")
        signInWithAppleBtn.setup(title: "Sign In With Apple", image: "apple.logo")
        signInWithAppleBtn.customButton.backgroundColor = .white
        signInWithAppleBtn.customButton.setTitleColor(.systemBlue, for: .normal)
        signInWithAppleBtn.customButton.layer.borderWidth = 1.0
        signUpBtn.setAnimateBounce()
    }
    
    private func handleBtn() {
        signInBtn.customButton.addTarget(self, action: #selector(onSignInBtnTap), for: .touchUpInside)
        signInWithAppleBtn.customButton.addTarget(self, action: #selector(onSignInWithAppleBtnTap), for: .touchUpInside)
    }
    
    @objc private func showPassword(_ sender: UITapGestureRecognizer) {
        passwordInputField.textField.isSecureTextEntry.toggle()
        imageView.image = UIImage(systemName: passwordInputField.textField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
    }
    
    @objc private func onSignInBtnTap() {
        validate()
    }
    
    @objc private func onSignInWithAppleBtnTap() {
        // Handle Apple sign-in
    }
   
    @IBAction private func onSignUpBtnTap() {
        navigateToRegisterView()
    }
}
