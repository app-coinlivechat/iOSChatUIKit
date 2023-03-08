//
//  MessageCellDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import Foundation
import CoinliveChatSDK

protocol MessageCellDelegate: AnyObject {
    func clickAllMessage(message: String, isMine: Bool, isTranslate: Bool)
    func clickUserProfile(userNickname: String?, profileImage: String?, isNft: Bool?, exchange: String?)
    func deleteMessage(chat: Chat)
    func blockMessage(memberId: String, isBlock: Bool)
    func addEmoji(chat: Chat, emojiType: EMOJI_TYPE)
    func deleteEmoji(chat: Chat, emojiType: EMOJI_TYPE)
}
