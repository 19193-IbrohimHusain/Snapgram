//
//  SettingEntity.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import Foundation

struct SettingEntity {
    let image: String
    let name: String
}

var listSetting: [SettingEntity] = [
    SettingEntity(image: "gearshape", name: "Settings and privacy"),
    SettingEntity(image: "at", name: "Threads"),
    SettingEntity(image: "chart.xyaxis.line", name: "Your Activity"),
    SettingEntity(image: "clock.arrow.circlepath", name: "Archive"),
    SettingEntity(image: "qrcode.viewfinder", name: "QR code"),
    SettingEntity(image: "bookmark", name: "Saved"),
    SettingEntity(image: "person.2", name: "Supervision"),
    SettingEntity(image: "checkmark.seal", name: "Meta Verified"),
    SettingEntity(image: "list.star", name: "Close Friends"),
    SettingEntity(image: "person.3", name: "Shared lists"),
    SettingEntity(image: "star", name: "Favorites")
]
