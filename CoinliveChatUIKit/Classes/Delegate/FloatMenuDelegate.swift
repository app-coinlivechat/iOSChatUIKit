//
//  FloatMenuDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/01.
//

import UIKit
import CoinliveChatSDK

protocol FloatMenuActionDelegate: AnyObject {
    func copy()
    func cancel()
    func block()
    func delete()
    func report()
    func emojiAction(_ emojiType: EMOJI_TYPE)
    func deleteEmojiAction(_ emojiType: EMOJI_TYPE)
}

protocol FloatMenuDelegate: AnyObject {
    func loadTextMenu(floatMenuActionDelegate: FloatMenuActionDelegate,
                      position: CGPoint,
                      isHeadMessage: Bool,
                      isMyMessage: Bool,
                      size: CGSize,
                      chat: Chat,
                      isBlockUser: Bool)
    func loadImageMenu(floatMenuActionDelegate: FloatMenuActionDelegate,
                       position: CGPoint,
                       isMyMessage: Bool,
                       image: UIImage,
                       chat: Chat,
                       isBlockUser: Bool)
    func loadMultiImageMenu(floatMenuActionDelegate: FloatMenuActionDelegate,
                       position: CGPoint,
                       isMyMessage: Bool,
                       images: Array<UIImage>,
                        size: CGSize,
                       chat: Chat,
                       isBlockUser: Bool)
    func loadAssetMenu(floatMenuActionDelegate: FloatMenuActionDelegate,
                       position: CGPoint,
                       isHeadMessage: Bool,
                       isMyMessage: Bool,
                       size: CGSize,
                       chat: Chat,
                       isBlockUser: Bool)
    func pressKeyboardCheck(pressMessageCallback: @escaping () -> ())
}

protocol MenuViewActionDelegate: AnyObject {
    func showAlert(description: String, confirmText: String, cancelText: String, eCallback: @escaping () -> ())
    func showReportAlert(chat: Chat)
    func closeMenu()
}

protocol MenuViewDelegate: AnyObject {
    func deletedMessage(messageId: String?, callback: @escaping (Bool) -> ())
}
