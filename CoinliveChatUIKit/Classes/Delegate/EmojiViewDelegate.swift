//
//  EmojiViewDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/07.
//

import Foundation
import CoinliveChatSDK

protocol EmojiViewDelegate: AnyObject {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool)
}
