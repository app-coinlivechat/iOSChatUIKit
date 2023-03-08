//
//  NotificationSettingDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import Foundation

protocol NotificationSettingDelegate: AnyObject {
    func reloadSettings(settings: Dictionary<String, Bool>)
}
