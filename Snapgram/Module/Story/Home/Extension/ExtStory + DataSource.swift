//
//  ExtStory + DataSource.swift
//  Snapgram
//
//  Created by Phincon on 27/12/23.
//

import Foundation
import UIKit
import SkeletonView

extension StoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoryTable(rawValue: section)
        switch tableSection {
        case .story:
            return 1
        case .feed :
            return listStory.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = SectionStoryTable(rawValue: indexPath.section)
        switch tableSection {
        case .story:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StoryTableCell
            cell.configure(with: listStory)
            cell.delegate = self
            
            return cell
        case .feed:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as FeedTableCell
            if !listStory.isEmpty {
                let feedEntity = listStory[indexPath.row]
                cell1.post = feedEntity
                cell1.configure(post: feedEntity)
            }
            cell1.indexSelected = indexPath.row
            cell1.delegate = self
            
            return cell1
        default: return UITableViewCell()
        }
    }
}

extension StoryViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return tables.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoryTable(rawValue: section)
        switch tableSection {
        case .story:
            return 1
        case .feed:
            return 2
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let tableSection = SectionStoryTable(rawValue: indexPath.section)
        switch tableSection {
        case .story:
            return String(describing: StoryTableCell.self)
        case .feed:
            return String(describing: FeedTableCell.self)
        default: return ""
        }
    }
}
