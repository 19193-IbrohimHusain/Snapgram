import FloatingPanel

enum BottomSheetViewTypes {
    case tip, half, full
}

class BaseBottomSheetController: BaseViewController {
    internal var floatingPanel = FloatingPanelController()
    
    private weak var contentVC: UIViewController? {
        didSet {
            guard let contentVC = contentVC else { return }
            prepareBottomSheet(contentVC: contentVC)
        }
    }
    
    private var floatingPanelDelegate: FloatingPanelControllerDelegate? {
        didSet {
            floatingPanel.delegate = floatingPanelDelegate
        }
    }
    
    internal func setupBottomSheet(contentVC: UIViewController?, floatingPanelDelegate: FloatingPanelControllerDelegate) {
        self.floatingPanelDelegate = floatingPanelDelegate
        prepareBottomSheet(contentVC: contentVC)
    }
    
    private func prepareBottomSheet( contentVC: UIViewController?) {
        floatingPanel.surfaceView.appearance.cornerRadius = BaseConstant.fpcCornerRadius
        floatingPanel.contentMode = .fitToBounds
        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingPanel.isRemovalInteractionEnabled = true
        floatingPanel.set(contentViewController: contentVC)
    }
}
