//
//  UserTableCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

class UserTableCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure(with user: ListStory) {
        userName.text = user.name
        userId.text = user.id
    }
}
