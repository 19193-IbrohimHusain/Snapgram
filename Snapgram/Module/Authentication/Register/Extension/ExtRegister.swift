import UIKit

extension RegisterViewController {
    internal func bindData() {
        vm.registerResponse.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.registerResponse = data
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                case .loading:
                    self.addLoading(self.signUpBtn.customButton)
                case .failed:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                    if let error = self.registerResponse?.message {
                        self.displayAlert(title: "Sign Up Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                    if let message = self.registerResponse?.message {
                        self.displayAlert(title: message, message: "Please Sign In to continue", completion:  {
                            self.navigateToLoginView()
                        })
                    }
                }
            }
        }).disposed(by: bag)
    }

    internal func actionSignUp() {
        signUpBtn.customButton.addTarget(self, action: #selector(onSignUpBtnTap(_:)), for: .touchUpInside)
    }

    @objc private func onSignUpBtnTap(_ sender: Any) {
        addLoading(signUpBtn.customButton)
        
        guard validateInputField(nameInputField, title: "Sign Up Failed", message: "Please Enter Your Name", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(emailInputField, title: "Sign Up Failed", message: "Please Enter Your Email", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(passwordInputField, title: "Sign Up Failed", message: "Please Enter Your Password", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(confirmPasswordInputField, title: "Sign Up Failed", message: "Please Confirm Your Password", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateEmail(candidate: emailInputField.textField.text!) else {
            displayAlert(title: "Sign Up Failed", message: "Please Enter Valid Email", completion:  { self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up") })
            return
        }
        
        guard validatePassword(candidate: passwordInputField.textField.text!) else {
            displayAlert(title: "Sign Up Failed", message: "Password must contain at least 8 characters, 1 Alphabet and 1 Number", completion:  {
                self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
            })
            return
        }
        
        guard confirmPasswordInputField.textField.text == passwordInputField.textField.text else {
            displayAlert(title: "Sign Up Failed", message: "Confirmed Password is not the same as Password you entered", completion:  {
                self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
            })
            return
        }
        
        signUp()
    }
    
    private func signUp(){
        let enteredName = nameInputField.textField.text!
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        vm.signUp(param: RegisterParam(name: enteredName, email: enteredEmail, password: enteredPassword))
    }
    
    internal func navigateToLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
}
