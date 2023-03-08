//
//  CoinliveChatViewModel.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/11.
//

import Foundation
import CoinliveChatSDK

class CoinliveChatViewModel {
    weak var coinliveChatViewModelDelegate: CoinliveChatViewModelDelegate?
    weak var chatUserCountDelegate: ChatUserCountDelegate?
    private var coinliveRestApi: CoinliveRestApi!
    private var coinliveChat: CoinliveChat!
    private weak var joinUserCountTimer: Timer?
    private weak var amaTimer: Timer?
    private var amaStatus: AMA_STATUS = .NONE
    private var amaInterval: Int = 0
    ///
    private var channel: Channel?
    private var customerUser: CustomerUser?
    private var customerName: String!
    internal var notificationMap: Dictionary<String, Bool> = [:]
    
    init(channel: Channel, customerUser: CustomerUser?, customerName: String, messageDelegate: MessageDelegate, noticeDelegate: NoticeDelegate, timeLimitDelegate: TimeLimitDelegate, coinliveChatViewModelDelegate: CoinliveChatViewModelDelegate) {
        self.coinliveChatViewModelDelegate = coinliveChatViewModelDelegate
        self.channel = channel
        self.customerUser = customerUser
        self.initializeCoinlive(channel: channel, customerName: customerName, messageDelegate: messageDelegate, noticeDelegate: noticeDelegate, amaDelegate: self, timeLimitDelegate: timeLimitDelegate)
        self.initializeJoinedUserCountTimer()
    }
    
    private func initializeCoinlive(channel: Channel, customerName: String, messageDelegate: MessageDelegate, noticeDelegate: NoticeDelegate, amaDelegate: AmaDelegate, timeLimitDelegate: TimeLimitDelegate) {
        self.coinliveRestApi = CoinliveRestApi()
        self.coinliveChat = CoinliveChat(coinId: channel.coinId, coinSymbol: channel.symbol!, customerName: customerName, messageDelegate: messageDelegate, noticeDelegate: noticeDelegate, amaDelegate: amaDelegate, timeLimitDelegate: timeLimitDelegate)
    }
    
    internal func loadChatData() {
        if let _ = self.customerUser {
            self.loadChannelNotificationInformation { [weak self] notificationSettings in
                guard let self = self else { return }
                self.notificationMap = notificationSettings
                do {
                    try self.coinliveChat.fetchMessage(notificationMap: notificationSettings)
                } catch {
                }
            }
            if let failedMessages = self.coinliveChat.getFailedMessages() {
                if failedMessages.count > 0 {
                    self.coinliveChatViewModelDelegate?.loadFailedMessages(chats: failedMessages)
                }
            }
        } else {
            do {
                try self.coinliveChat.fetchMessage(notificationMap: [:])
            } catch {
            }
        }
    }
    
    internal func copyToChannelLink() {
        if let symbol = self.channel?.symbol, let coinId = self.channel?.coinId {
            self.coinliveChat.createDynamicLink(symbol: symbol, coinId: coinId, callback: { [weak self] url in
                guard let url = url else { return }
                self?.coinliveChatViewModelDelegate?.shareChannelUrl(url: "\(url)")
                
            })
        }
    }
    
    internal func sendMessage(message: String) {
        if let customerUser = self.customerUser {
            try? self.coinliveChat.sendMessage(message: message, myInfo: customerUser)
        }
    }
    
    internal func deleteDatabaseMessage(messageId: String) {
        self.coinliveChat.deleteFailMessage(messageId: messageId)
    }
    
    internal func deleteMessage(chat: Chat) {
        self.coinliveChat.deleteMessage(chat: chat)
    }
    
    internal func getReportTypes(callback: @escaping (Array<ReportType>) -> ()) {
        self.coinliveRestApi.getReportTypes(onSuccess: { types in
            callback(types)
        }, onFailed: { error in
            
        })
    }
    
    internal func reportUser(reportMessage: String, reportMemberId: String, reportTypeId: String, callback: @escaping (Bool) -> ()) {
        self.coinliveRestApi.reportUser(reportMessage: reportMessage,
                                        reportMemberId: reportMemberId,
                                        reportTypeId: reportTypeId,
                                        onSuccess: {
            callback(true)
        },
                                        onFailed: { error in
            callback(false)
        })
    }
    
    internal func addEmoji(chat: Chat, emoji: EMOJI_TYPE) {
        if let customerUser = self.customerUser {
            self.coinliveChat.addEmoji(chat: chat, memberId: customerUser.memberId, emoji: emoji)
        }
    }
    
    internal func deleteEmoji(chat: Chat, emoji: EMOJI_TYPE) {
        if let customerUser = self.customerUser {
            self.coinliveChat.deleteEmoji(chat: chat, memberId: customerUser.memberId, emoji: emoji)
        }
        
    }
    
    internal func blockUser(memberId: String, callback: @escaping (Array<String>?) -> ()) {
        self.coinliveRestApi.blockUser(blockMemberId: memberId,
                                       onSuccess: { blockMember in
            callback(blockMember.memberIds)
        },                              onFailed: { _ in callback(nil)})
    }
    
    internal func unBlockUser(memberId: String, callback: @escaping (Array<String>?) -> ()) {
        self.coinliveRestApi.deleteBlockUser(blockMemberId: memberId,
                                       onSuccess: { blockMember in
            callback(blockMember.memberIds)
        },                              onFailed: { _ in callback(nil)})
    }
    
    internal func notificationReFetch(notificationMap: Dictionary<String, Bool>) {
        guard let coinId = self.channel?.coinId else { return }
        let isNotificationCount = notificationMap.count
        var apiCount = 0
        
        notificationMap.forEach { (key, item) in
            if item {
                self.coinliveRestApi.setNotification(coinId: coinId, notificationType: key, onSuccess: { [weak self] notificationSettings in
                    guard let self = self else { return }
                    self.notificationMap[key] = true
                    apiCount = apiCount + 1
                    if apiCount == isNotificationCount {
                        self.reloadMessage()
                    }
                }, onFailed: { [weak self] error in
                    guard let self = self else { return }
                    apiCount = apiCount + 1
                    if apiCount == isNotificationCount {
                        self.reloadMessage()
                    }
                })
                
            } else {
                self.coinliveRestApi.deleteNotification(coinId: coinId, notificationType: key, onSuccess: { [weak self] notificationSettings in
                    guard let self = self else { return }
                    self.notificationMap[key] = false
                    apiCount = apiCount + 1
                    if apiCount == isNotificationCount {
                        self.reloadMessage()
                    }
                    
                }, onFailed: { [weak self] error in
                    guard let self = self else { return }
                    apiCount = apiCount + 1
                    if apiCount == isNotificationCount {
                        self.reloadMessage()
                    }
                    
                })
            }
        }
    }
    
    internal func setNickname(nickname: String, callback: @escaping (Bool, String?) -> ()) {
        guard let customerId = self.customerUser?.customerId else { return }
        self.coinliveRestApi.isAvailableNickname(nickname: nickname,
                                                 customerId: customerId,
                                                 onSuccess: { [weak self] in
            guard let self = self else { return }
            self.coinliveRestApi.setNickname(nickname: nickname,
                                             customerId: customerId,
                                             onSuccess: { response in
                callback(true, nil)
            },
                                             onFailed: { error in
                callback(false, error.message)
            })
        },
                                                 onFailed: { error in
            callback(false, error.message)
        })
    }
    
    internal func profileImageUpload(data: Data, callback: @escaping (Bool, String?) -> ()) {
        
        self.coinliveRestApi.uploadProfileImage(image: data,
                                         onSuccess: { response in
            callback(true, nil)
        },
                                         onFailed: { error in
            callback(false, error.message)
        })
    }
    
    internal func chatRoomJoin() {
        if let coinId = self.channel?.coinId {
            self.coinliveRestApi.userJoin(coinId: coinId, onSuccess: { },
                                          onFailed: { error in
            })
        }
    }
    
    internal func chatRoomLeave() {
        if let coinId = self.channel?.coinId {
            self.coinliveRestApi.userLeave(coinId: coinId, onSuccess: { },
                                          onFailed: { error in
            })
        }
    }
    
    internal func loadCustomerUserInfo(callback: @escaping (CustomerUser) -> ()) {
        coinliveRestApi.getCustomerMemberInfo(
            onSuccess: { [weak self] customerUser in
                guard let self = self else { return }
                self.customerUser = customerUser
                callback(customerUser)
            },
            onFailed: { error in
            })
    }
    
    private func reloadMessage() {
        self.coinliveChat.reloadMessages(notificationMap: notificationMap)
        if let failedMessages = self.coinliveChat.getFailedMessages() {
            if failedMessages.count > 0 {
                self.coinliveChatViewModelDelegate?.loadFailedMessages(chats: failedMessages)
            }
        }
    }
    
    private func initializeJoinedUserCountTimer() {
        if joinUserCountTimer == nil {
            self.loadJoinedUserCount()
            joinUserCountTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                self.loadJoinedUserCount()
            })
        }
    }
    
    private func initializeAmaTimer() {
        if amaTimer == nil {
            amaTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                let dayToStart = self.amaInterval / (60 * 60 * 24)
                let hourToStart = (self.amaInterval % (60 * 60 * 24)) / (60 * 60)
                let minuteToStart = ((self.amaInterval % (60 * 60 * 24)) % (60 * 60)) / 60
                let secondToStart = ((self.amaInterval % (60 * 60 * 24)) % (60 * 60)) % 60
                self.amaInterval = self.amaInterval - 1
                if self.amaInterval < 0 {
                    timer.invalidate()
                    self.amaTimer = nil
                    self.amaStatus = .LIVE
                    self.coinliveChatViewModelDelegate?.ama(status: .LIVE)
                    
                } else {
                    self.coinliveChatViewModelDelegate?.amaTick(day: dayToStart, hour: hourToStart, minute: minuteToStart, second: secondToStart)
                }
            })
        }
    }
    
    private func loadJoinedUserCount() {
        guard let coinId = self.channel?.coinId else { return }
        self.coinliveRestApi.getUserCount(
            coinId: coinId,
            onSuccess: { [weak self] count in
                guard let self = self else { return }
                if self.amaStatus != .LIVE {
                    if let status = count.status {
                        self.coinliveChatViewModelDelegate?.chatStatus(status: status)
                    }
                }
                self.chatUserCountDelegate?.updateCount(count: count.count ?? 0)
            },
            onFailed: { error in
                
            })
    }
    
    private func loadChannelNotificationInformation(callback: @escaping(Dictionary<String, Bool>) -> ()) {
        guard let coinId = self.channel?.coinId else { return }
        coinliveRestApi.getNotificationSetting(
            coinId: coinId,
            onSuccess: { notificationSettings in
                callback(notificationSettings.notificationDictionary)
            }, onFailed: { error in
            })
    }
    
    internal func close() {
        self.chatRoomLeave()
        self.coinliveChat.close()
        self.joinUserCountTimer?.invalidate()
        self.amaTimer?.invalidate()
    }
    
    internal func backgroundToFront(difference: Int) {
        if self.amaStatus == .BEFORE {
            if difference > 1 {
                self.amaInterval = self.amaInterval - difference + 1
            } else {
                self.amaInterval = self.amaInterval - difference
            }
        }
    }
}

extension CoinliveChatViewModel: AmaDelegate {
    public func amaNoticeListener(ama: CoinliveChatSDK.Ama) {
        if self.amaTimer != nil {
            self.amaTimer?.invalidate()
            self.amaTimer = nil
            self.amaInterval = 0
            self.amaStatus = .NONE
        }
        
        if ama.endTime == nil { // 진행 중 or 진행 전
            let currentDate = Date()
            let startDate = Date(timeIntervalSince1970: TimeInterval(ama.startTime / 1000))
            let interval = Int(currentDate.distance(to: startDate))
            if interval < 1 {
                self.amaInterval = 0
                self.amaStatus = .LIVE
                self.coinliveChatViewModelDelegate?.ama(status: .LIVE)
                return
            }
            self.amaInterval = interval
            self.initializeAmaTimer()
            self.amaStatus = .BEFORE
            self.coinliveChatViewModelDelegate?.ama(status: .BEFORE)
        } else { // 종료
            self.amaInterval = 0
            self.amaStatus = .DONE
            self.coinliveChatViewModelDelegate?.ama(status: .DONE)
            return
        }
    }
}
