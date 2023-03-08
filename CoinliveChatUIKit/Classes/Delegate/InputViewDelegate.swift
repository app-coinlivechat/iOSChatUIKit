//
//  InputViewDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import Foundation


protocol InputViewDelegate: AnyObject {
    func changeInputViewHeight(height: CGFloat)
    func sendMessage(message: String)
}
