//
//  DetailUserProfileCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class DetailUserProfileCell: UICollectionViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var totalPost: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    private var isFollowed: Bool = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        followBtn.setAnimateBounce()
        profileImg.layer.cornerRadius = profileImg.bounds.width / 2
    }
    
    internal func configure(with post: ListStory, postCount: Int) {
        userName.text = post.name
        userID.text = post.id
        totalPost.text = "\(postCount)"
    }
    
    private func configureFollowBtn() {
        followBtn.setTitle(isFollowed ? "Unfollow" : "Follow", for: .normal)
        followBtn.setTitleColor(isFollowed ? .black : .white, for: .normal)
        followBtn.tintColor = isFollowed ? .opaqueSeparator : .systemBlue
    }
    
    @IBAction func onFollowBtnTap() {
        isFollowed.toggle()
        configureFollowBtn()
    }

}
