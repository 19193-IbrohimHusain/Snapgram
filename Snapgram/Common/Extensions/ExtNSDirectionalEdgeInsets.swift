//
//  ExtNSDirectionalEdgeInsets.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func uniform(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: size, leading: size, bottom: size, trailing: size)
    }
    
    static func horizontalInsets(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: size, bottom: 0, trailing: size)
    }
    
    static func verticalInsets(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: size, leading: 0, bottom: size, trailing: 0)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    static func small() -> NSDirectionalEdgeInsets {
        return .uniform(size: 5)
    }
    
    static func medium() -> NSDirectionalEdgeInsets {
        return .uniform(size: 15)
    }
    
    static func large() -> NSDirectionalEdgeInsets {
        return .uniform(size: 30)
    }
}
