import UIKit
import Lottie

class SplashScreenViewController: BaseViewController {
    
    @IBOutlet weak var splashScreen: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigationController?.setViewControllers([self.isTokenExistInKeychain() ? TabBarViewController() : LoginViewController()], animated: true)
        }
        splashScreen.contentMode = .scaleAspectFill
        splashScreen.loopMode = .playOnce
        splashScreen.play()
    }
}
