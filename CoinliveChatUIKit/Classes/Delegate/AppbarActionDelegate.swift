//
//  AppbarActionDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import Foundation

protocol AppbarActionDelegate: AnyObject {
    func actionFold()
    func actionChannelShare()
    func actionNotificationSetting()
    func actionTranslateSetting()
    func actionProfileSetting()
}
