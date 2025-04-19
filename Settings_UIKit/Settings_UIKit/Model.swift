//
//  Model.swift
//  Settings_UIKit
//
//  Created by Артём on 19.04.2025.
//

import UIKit

struct SettingsInfo: Identifiable {
    let id = UUID().uuidString
    let systemPic: UIImage?
    let title: String
    let subtitle: String?
}
