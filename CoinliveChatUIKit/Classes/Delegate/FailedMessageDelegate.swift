//
//  FailedMessageDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/14.
//

import Foundation
import CoinliveChatSDK

protocol FailedMessageDelegate: AnyObject {
    func cancel(chat: Chat)
    func resend(chat: Chat)
}
