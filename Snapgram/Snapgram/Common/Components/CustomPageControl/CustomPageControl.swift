//
//  CustomPageControl.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit

class CustomPageControl: UIPageControl {
    
    private var selectedIndex: Int = 0
    private var remainingDecimal: CGFloat = 0
    
    // active page indicator
    open var activeColor = UIColor.label
    
    // inactive indicator
    open var inactiveColor = UIColor.separator
    
    // active size
    public var activeSize = CGSize(width: 16, height: 6)
    
    // inactive size
    public var inactiveSize = CGSize(width: 6, height: 6)
    
    // page control position
    public var isCenter: Bool = true
    
    private let magicTag = "KMPageControl".hash
    
    // spacing
    public var dotSpacing: CGFloat = 5.0 {
        didSet {
            self.pageIndicatorTintColor = .clear
            self.currentPageIndicatorTintColor = .clear
            updateDots()
        }
    }
    
    override var numberOfPages: Int {
        didSet {
            // remove all subviews before add new subviews
            for view in self.subviews {
                view.removeFromSuperview()
            }
        }
    }
    
    override public var currentPage: Int {
        didSet {
            self.pageIndicatorTintColor = .clear
            self.currentPageIndicatorTintColor = .clear
            updateDots()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.pageIndicatorTintColor = .clear
        self.currentPageIndicatorTintColor = .clear
        updateDots(animated: false)
    }
    
    func updateDots(animated: Bool = true) {
        guard numberOfPages > 0 else { return }
        let view = self
        let spacing = dotSpacing
        let dotsTotalW: CGFloat = CGFloat(numberOfPages - 1)
        * (inactiveSize.width + spacing)
        + activeSize.width
        let totalW = view.bounds.width
        
        var startX: CGFloat = (totalW - dotsTotalW)/2.0
        
        if !isCenter {
            startX = 0
        }
        
        for idx in (0..<numberOfPages) {
            let isActive = idx == currentPage
            let color = isActive ? activeColor : inactiveColor
            let size = isActive ? activeSize: inactiveSize
            let imageV = self.imageView(for: view, index: idx)
            let pointX = startX
            let pointY = view.bounds.midY - size.height/2.0
            
            let change = {
                imageV?.frame = .init(x: pointX, y: pointY, width: size.width, height: size.height)
                imageV?.layer.cornerRadius = min(size.width, size.height)/2.0
                imageV?.backgroundColor = color
            }
            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    change()
                })
            }else {
                change()
            }
            startX += size.width + spacing
        }
    }
    func imageView(for view: UIView, index page: Int) -> UIImageView?   {
        let tag = magicTag + page
        if let imageV = view.viewWithTag(tag) as? UIImageView {
            return imageV
        }
        let imageV  = UIImageView()
        imageV.tag = tag
        view.addSubview(imageV)
        return imageV
    }
}
