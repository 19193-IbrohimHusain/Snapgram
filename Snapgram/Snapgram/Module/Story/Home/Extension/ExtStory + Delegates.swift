import Foundation
import UIKit

extension StoryViewController: FeedTableCellDelegate {
    func navigateToDetailUser(post: ListStory) {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        if post.name == user.username {
            let vc = TabBarViewController()
            vc.selectedIndex = 4
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.setViewControllers([vc], animated: true)
        } else {
            let vc = DetailUserViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.detailUser = post
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getLocationName(lat: Double?, lon: Double?, completion: @escaping ((String) -> Void)) {
        if let lat = lat, let lon = lon {
            getLocationNameFromCoordinates(lat: lat, lon: lon) { name in
                completion(name)
            }
        }
    }
    
    func openComment() {
        self.present(floatingPanel, animated: true)
    }
    
    func addLike(cell: FeedTableCell) {
        guard let indexPath = storyTable?.indexPath(for: cell) else { return }
        var post = listStory[indexPath.row]
        post.isLiked.toggle()
        post.likesCount = post.isLiked ? post.likesCount + 1 : post.likesCount - 1
        self.listStory[indexPath.row] = post
        UIView.performWithoutAnimation {
            self.storyTable.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension StoryViewController: StoryTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
