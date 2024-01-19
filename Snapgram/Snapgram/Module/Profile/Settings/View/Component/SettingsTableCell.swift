//
//  SettingsTableCell.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import UIKit

class SettingsTableCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func configure(with settings: SettingEntity) {
        imgView.image = UIImage(systemName: settings.image)
        name.text = settings.name
    }
    
}
