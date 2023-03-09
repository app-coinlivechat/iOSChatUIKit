//
//  CoinliveUIKit.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2023/03/09.
//

import Foundation

public class CoinliveUIKit {
    public static let shared = CoinliveUIKit()
    private init() {}
    internal var inputViewUnknownUserProtocol: InputViewUnknownUserProtocol?
    public func setInputViewUnknownUserProtocol(inputViewUnknownUserProtocol: InputViewUnknownUserProtocol) {
        self.inputViewUnknownUserProtocol = inputViewUnknownUserProtocol
    }
}
