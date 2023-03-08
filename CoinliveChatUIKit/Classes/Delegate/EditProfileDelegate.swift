//
//  EditProfileDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/21.
//

import Foundation
import UIKit


protocol EditProfileDelegate: AnyObject {
    func cancelEditProfile()
    func saveEditProfile(nickname: String?, profileImage: Data?)
}
