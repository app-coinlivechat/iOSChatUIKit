//
//  ReportAlertActionDelegate.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/02.
//

import Foundation

protocol ReportAlertActionDelegate: AnyObject {
    func reportConfirm(reportId: String, memberId: String, reportMessage: String)
    func reportCancel()
}
