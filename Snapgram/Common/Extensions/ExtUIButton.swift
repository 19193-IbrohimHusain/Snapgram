import UIKit

extension UIButton {
    
    func setAnimateBounce() {
        self.addAction(UIAction { _ in
            self.onTapDownAnimateBounce()
        }, for: .touchDown)
        self.addAction(UIAction { _ in
            self.onTapUpAnimateBounce()
        }, for: .touchUpInside)
    }
    
    func onTapDownAnimateBounce() {
        UIView.animate(withDuration: 0.092, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
    
    func onTapUpAnimateBounce() {
        UIView.animate(withDuration: 0.092, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
