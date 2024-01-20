//
//  SectionStoryEnum.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

enum SectionStoryTable: Int, CaseIterable {
    case story, feed
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .story:
            return StoryTableCell.self
        case .feed:
            return FeedTableCell.self
        }
    }
}
