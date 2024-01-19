import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {
    
    static let shared = CustomFloatingPanelLayout()
    
    let position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full:
            return 0.8
        case .half:
            return 0.5
        default:
            return 0
        }
    }
}

extension FloatingPanelState {
    static let lastQuart: FloatingPanelState = FloatingPanelState(rawValue: "lastQuart", order: 750)
    static let firstQuart: FloatingPanelState = FloatingPanelState(rawValue: "firstQuart", order: 250)
}

class FloatingPanelLayoutWithCustomState: FloatingPanelBottomLayout {
    override var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
            .lastQuart: FloatingPanelLayoutAnchor(fractionalInset: 0.75, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .firstQuart: FloatingPanelLayoutAnchor(fractionalInset: 0.25, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 20.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
