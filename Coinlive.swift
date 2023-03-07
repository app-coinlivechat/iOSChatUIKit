//
//  Coinlive.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2023/03/07.
//

import Foundation


public class Coinlive {
    private let version = 1.1
    public let getName = "My name is Coinlive"
    public func checkMyName() -> String {
        return getName
    }
    
    public func testVersion() -> Double {
        return version
    }
}
