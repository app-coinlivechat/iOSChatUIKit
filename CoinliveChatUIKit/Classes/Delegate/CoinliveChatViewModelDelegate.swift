//
//  ViewModelDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/13.
//

import Foundation
import CoinliveChatSDK

protocol CoinliveChatViewModelDelegate: AnyObject {
    func ama(status: AMA_STATUS)
    func amaTick(day: Int, hour: Int, minute: Int, second: Int)
    func shareChannelUrl(url: String)
    func loadFailedMessages(chats: [Chat])
    func chatStatus(status: USER_STATUS)
}
