//
//  SectionDetailUserEnum.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

enum SectionDetailUser: Int, CaseIterable {
    case profile, post
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .profile:
            return DetailUserProfileCell.self
        case .post:
            return DetailUserPostCollectionCell.self
        }
    }
    
    static var sectionIdentifiers: [SectionDetailUser: String] {
        return [
            .profile: String(describing: DetailUserProfileCell.self),
            .post: String(describing: UserPostCell.self)
        ]
    }
}
