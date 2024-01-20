//
//  SettingsViewController.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.registerCellWithNib(SettingsTableCell.self)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableCell
        let settingEntity = listSetting[indexPath.row]
        cell.configure(with: settingEntity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
