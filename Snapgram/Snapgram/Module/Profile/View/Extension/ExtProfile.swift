//
//  ExtProfile.swift
//  Snapgram
//
//  Created by Phincon on 05/12/23.
//

import Foundation
import SkeletonView

extension ProfileViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return tables.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionProfileTable(rawValue: section)
        switch tableSection {
        case .profile, .category, .post:
            return 1
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let tableSection = SectionProfileTable(rawValue: indexPath.section)
        switch tableSection {
        case .profile:
            return String(describing: ProfileTableCell.self)
        case .category:
            return String(describing: CategoryTableCell.self)
        case .post:
            return String(describing: PostTableCell.self)
        default: return ""
        }
    }
}

extension ProfileViewController: ProfileTableCellDelegate {
    func editProfile() {
        let epvc = EditProfileViewController()
        epvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(epvc, animated: true)
    }
    
    func shareProfile() {
        deleteToken()
        BaseConstant.deleteUserFromUserDefaults()
        let vc = LoginViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func discover() {
        let dvc = EditProfileViewController()
        dvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension ProfileViewController: CategoryTableCellDelegate {
    func setCurrentSection(index: Int) {
        self.scrollToMenuIndex(sectionIndex: index)
    }
}

extension ProfileViewController: PostTableCellDelegate {
    func didEndDecelerating(scrollView: UIScrollView) {
        let index = IndexPath(row: 0, section: 1)
        if let cell = profileTable.cellForRow(at: index) as? CategoryTableCell {
            let index = Int(scrollView.contentOffset.x / view.frame.width)
            let indexPath = IndexPath(item: index, section: 0)
            cell.categoryCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func didScroll(scrollView: UIScrollView) {
        let index = IndexPath(row: 0, section: 1)
        if let cell = profileTable.cellForRow(at: index) as? CategoryTableCell {
            cell.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
        }
    }
    
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
