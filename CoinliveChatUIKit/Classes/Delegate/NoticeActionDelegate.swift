//
//  NoticeActionDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/29.
//

import Foundation

protocol NoticeActionDelegate: AnyObject {
    func clickShowAll(message: String)
    func foldNotice()
    func expandNotice(height: CGFloat)
    func collapseNotice()
}
