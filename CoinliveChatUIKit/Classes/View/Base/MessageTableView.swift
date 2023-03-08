//
//  MessageTableView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//

import UIKit
import CoinliveChatSDK
class MessageTableView: UIView {
    private let FAIL_TAG = "FAIL"
    private weak var messageTableViewDelegate: MessageTableViewDelegate?
    internal weak var floatMenuDelegate: FloatMenuDelegate?
    private weak var tvMessages: UITableView?
    private weak var vNewMessage: UIView?
    private weak var ivNewMessageProfile: UIImageView?
    private weak var lbNewMessageNickname: UILabel?
    private weak var lbNewMessageContent: UILabel?
    private weak var ivNewMessageDropDown: UIImageView?
    private weak var btnDown: UIButton?
    
    private var channel: Channel!
    private var messageList: Array<Chat> = []
    private var customerUser: CustomerUser?
    private weak var rcTvMessage: UIRefreshControl?
    
    private let dropDownSize: CGFloat = 38.0
    private let vNewMessageHeight: CGFloat = 36.0
    private let newMessageProfileImageSize: CGFloat = 24.0
    private let newMessageDropDownSize: CGFloat = 20.0
    private var isBottomOffset: Bool = false
    private var emojiBottomOffset: Bool = false
    private var isNewMessageShow: Bool = false
    private var isNewMessageClickController: Bool = false
    private var blockMemberIdList: Array<String> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUi()
    }
    
    deinit {
        self.tvMessages = nil
        self.messageList.removeAll()
    }
    
    private func initUi() {
        self.backgroundColor = .background
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let rcTvMessage = UIRefreshControl()
        self.rcTvMessage = rcTvMessage
        
        let tvMessages = UITableView(frame: .zero, style: .grouped)
        tvMessages.translatesAutoresizingMaskIntoConstraints = false
        tvMessages.separatorStyle = .none
        tvMessages.backgroundColor = .background
        tvMessages.delegate = self
        tvMessages.dataSource = self
        tvMessages.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tvMessages.refreshControl = rcTvMessage// Remove space at bottom of tableView.
        tvMessages.tableFooterView =
        UIView(frame: CGRect(origin: .zero,
                             size: CGSize(width:CGFloat.leastNormalMagnitude,
                                          height: CGFloat.leastNormalMagnitude)))
        rcTvMessage.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        self.addSubview(tvMessages)
        self.tvMessages = tvMessages
        
        let vNewMessage = UIView()
        vNewMessage.translatesAutoresizingMaskIntoConstraints = false
        vNewMessage.backgroundColor = .backgroundNewMessage
        vNewMessage.layer.cornerRadius = 6.0
        vNewMessage.isUserInteractionEnabled = true
        vNewMessage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dropDown)))
        
        let ivNewMessageProfile = UIImageView()
        ivNewMessageProfile.translatesAutoresizingMaskIntoConstraints = false
        ivNewMessageProfile.layer.cornerRadius = self.newMessageProfileImageSize / 2.0
        vNewMessage.addSubview(ivNewMessageProfile)
        self.ivNewMessageProfile = ivNewMessageProfile
        
        let lbNewMessageNickname = UILabel()
        lbNewMessageNickname.translatesAutoresizingMaskIntoConstraints = false
        lbNewMessageNickname.textColor = .labelNewMessageNickname
        lbNewMessageNickname.font = UIFont.systemFont(ofSize: 12.0)
        lbNewMessageNickname.textAlignment = .left
        lbNewMessageNickname.adjustsFontSizeToFitWidth = true
        vNewMessage.addSubview(lbNewMessageNickname)
        self.lbNewMessageNickname = lbNewMessageNickname
        
        let lbNewMessageContent = UILabel()
        lbNewMessageContent.translatesAutoresizingMaskIntoConstraints = false
        lbNewMessageContent.textColor = .label
        lbNewMessageContent.font = UIFont.systemFont(ofSize: 12.0)
        lbNewMessageContent.numberOfLines = 1
        lbNewMessageContent.lineBreakMode = .byTruncatingTail
        vNewMessage.addSubview(lbNewMessageContent)
        self.lbNewMessageContent = lbNewMessageContent
        
        let ivNewMessageDropDown = UIImageView()
        ivNewMessageDropDown.translatesAutoresizingMaskIntoConstraints = false
        ivNewMessageDropDown.image = .downArrow
        vNewMessage.addSubview(ivNewMessageDropDown)
        self.addSubview(vNewMessage)
        vNewMessage.isHidden = true
        self.ivNewMessageDropDown = ivNewMessageDropDown
        self.vNewMessage = vNewMessage
        
        let btnDown = UIButton(type: .custom)
        btnDown.translatesAutoresizingMaskIntoConstraints = false
        btnDown.backgroundColor = .backgroundDropDown
        btnDown.setImage(.downArrow, for: .normal)
        btnDown.layer.cornerRadius = dropDownSize / 2.0
        btnDown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dropDown)))
        self.addSubview(btnDown)
        btnDown.isHidden = true
        self.btnDown = btnDown
        
        NSLayoutConstraint.activate([
            tvMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tvMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tvMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tvMessages.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            btnDown.widthAnchor.constraint(equalToConstant: self.dropDownSize),
            btnDown.heightAnchor.constraint(equalToConstant: self.dropDownSize),
            btnDown.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            btnDown.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0),
            vNewMessage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            vNewMessage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -4.0),
            vNewMessage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            vNewMessage.heightAnchor.constraint(equalToConstant: self.vNewMessageHeight),
            
            ivNewMessageProfile.heightAnchor.constraint(equalToConstant: self.newMessageProfileImageSize),
            ivNewMessageProfile.widthAnchor.constraint(equalToConstant: self.newMessageProfileImageSize),
            ivNewMessageProfile.leadingAnchor.constraint(equalTo: vNewMessage.leadingAnchor, constant: 6.0),
            ivNewMessageProfile.centerYAnchor.constraint(equalTo: vNewMessage.centerYAnchor),
            
            lbNewMessageNickname.leadingAnchor.constraint(equalTo: ivNewMessageProfile.trailingAnchor, constant: 6.0),
            lbNewMessageNickname.centerYAnchor.constraint(equalTo: vNewMessage.centerYAnchor),
            lbNewMessageNickname.widthAnchor.constraint(lessThanOrEqualToConstant: 30.0),
            
            lbNewMessageContent.leadingAnchor.constraint(equalTo: lbNewMessageNickname.trailingAnchor, constant: 6.0),
            lbNewMessageContent.centerYAnchor.constraint(equalTo: vNewMessage.centerYAnchor),
            lbNewMessageContent.trailingAnchor.constraint(equalTo: ivNewMessageDropDown.leadingAnchor, constant: -6.0),
            
            ivNewMessageDropDown.heightAnchor.constraint(equalToConstant: self.newMessageDropDownSize),
            ivNewMessageDropDown.widthAnchor.constraint(equalToConstant: self.newMessageDropDownSize),
            ivNewMessageDropDown.trailingAnchor.constraint(equalTo: vNewMessage.trailingAnchor, constant: -6.0),
            ivNewMessageDropDown.centerYAnchor.constraint(equalTo: vNewMessage.centerYAnchor)
        ])
        tvMessages.register(UserMessageCell.self, forCellReuseIdentifier: "UserMessageCell")
        tvMessages.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        tvMessages.register(ServerMessageCell.self, forCellReuseIdentifier: "ServerMessageCell")
        tvMessages.register(UserImageMessageCell.self, forCellReuseIdentifier: "UserImageMessageCell")
        tvMessages.register(UserMultiImageMessageCell.self, forCellReuseIdentifier: "UserMultiImageMessageCell")
        tvMessages.register(UserAssetMessageCell.self, forCellReuseIdentifier: "UserAssetMessageCell")
        tvMessages.register(MyImageMessageCell.self, forCellReuseIdentifier: "MyImageMessageCell")
    }
    
    internal func resizeTableView() {
        if getCurrentYOffset() {
            self.scrollToBottom()
        }
    }
    
    internal func addBlockMemberIdList(list: Array<String>) {
        self.blockMemberIdList = list
        if let indexPaths = self.tvMessages?.indexPathsForVisibleRows {
            self.tvMessages?.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    internal func reloadFromrefresh() -> Bool {
        return (self.tvMessages?.contentOffset.y ?? 0) >= 0.0
    }
    
    internal func getCurrentYOffset(height: CGFloat = 0) -> Bool {
        let height = ((self.tvMessages?.frame.size.height ?? 0) + height)
        let contentYOffset = self.tvMessages?.contentOffset.y ?? 0
        let distanceFromBottom = (self.tvMessages?.contentSize.height ?? 0) - contentYOffset
        return distanceFromBottom < (height + 10)
    }
    
    internal func setUpData(customerUser: CustomerUser?, channel: Channel, messageTableViewDelegate: MessageTableViewDelegate) {
        self.customerUser = customerUser
        self.channel = channel
        self.messageTableViewDelegate = messageTableViewDelegate
    }
    
    internal func addMessages(chatList: Array<CoinliveChatSDK.Chat>) {
        DispatchQueue.main.async {
            self.rcTvMessage?.endRefreshing()
        }
        let isScroll = self.reloadFromrefresh()
        
        if self.messageList.count == 0 {
            self.messageList.append(contentsOf: chatList.reversed()) // first가 가장 하단
            self.tvMessages?.reloadData()
        } else {
            var paths: [IndexPath] = []
            
            for i in 0..<chatList.count {
                paths.append(IndexPath(row: i, section: 0))
            }
            
            self.messageList.insert(contentsOf: chatList.reversed(), at: 0)
            UIView.performWithoutAnimation {
                self.tvMessages?.insertRows(at: paths, with: .none)
                self.tvMessages?.reloadRows(at: [IndexPath(row: chatList.count, section: 0)], with: .none)
                self.tvMessages?.scrollToRow(at: IndexPath(row: chatList.count, section: 0), at: .bottom, animated: false)
            }
        }
        
        UIView.performWithoutAnimation {
            guard let tvMessages = self.tvMessages else {
                return
            }
            
            if isScroll {
                let row = tvMessages.numberOfRows(inSection: 0) - 1
                if row < 0 {
                    return
                }
                tvMessages.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    internal func updateChat(chat: Chat) {
        for (index, item) in messageList.enumerated() {
            if item.messageId == chat.messageId {
                self.messageList.remove(at: index)
                self.messageList.insert(chat, at: index)
                UIView.performWithoutAnimation {
                    self.tvMessages?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
        
        if self.emojiBottomOffset {
            UIView.performWithoutAnimation {
                self.tvMessages?.scrollToRow(at: self.tvMessages!.indexPathsForVisibleRows!.last!, at: .bottom, animated: false)
            }
        } else {
            if let emojis = chat.emoji {
                if emojis.count > 0 {
                    if emojis.values.contains(where: { emoji in emoji.count > 0}) {
                        UIView.performWithoutAnimation {
                            self.tvMessages?.layoutIfNeeded()
                            self.tvMessages?.setContentOffset(CGPoint(x: self.tvMessages?.contentOffset.x ?? 0, y: (self.tvMessages?.contentOffset.y ?? 0.0) + 27.0), animated: false)
                        }
                    } else {
                        UIView.performWithoutAnimation {
                            self.tvMessages?.layoutIfNeeded()
                            self.tvMessages?.setContentOffset(CGPoint(x: self.tvMessages?.contentOffset.x ?? 0, y: (self.tvMessages?.contentOffset.y ?? 0.0) - 27.0), animated: false)
                        }
                    }
                } else {
                    UIView.performWithoutAnimation {
                        self.tvMessages?.layoutIfNeeded()
                        self.tvMessages?.setContentOffset(CGPoint(x: self.tvMessages?.contentOffset.x ?? 0, y: (self.tvMessages?.contentOffset.y ?? 0.0) - 27.0), animated: false)
                    }
                }
            }
        }
    }
    
    internal func reloadMessages(chatList: Array<CoinliveChatSDK.Chat>) {
        self.messageList = []
        self.messageList.append(contentsOf: chatList.reversed())
        self.tvMessages?.reloadData()
        if chatList.isEmpty {
            return
        }
        self.scrollToBottom()
    }
    
    func scrollToBottom() {
        guard let tvMessages = self.tvMessages else { return }
        if tvMessages.numberOfSections == 0 {
            return
        }
        
        if self.messageList.isEmpty {
            return
        }
            
        DispatchQueue.main.async {
            let section: Int
            section = (tvMessages.numberOfSections - 1)
            let row = tvMessages.numberOfRows(inSection: section) - 1
            tvMessages.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: false)
            self.isBottomOffset = true
            self.checkDropView()
        }
    }
    
    internal func deletedMessage(chat: Chat) {
        if let targetIndex = self.messageList.firstIndex(where: { target in target.messageId == chat.messageId }) {
            self.messageList.remove(at: targetIndex)
            UIView.performWithoutAnimation {
                self.tvMessages?.deleteRows(at: [IndexPath(row: targetIndex, section: 0)], with: .none)
                self.tvMessages?.reloadRows(at: getNearRows(chat: chat, targetIndex: targetIndex), with: .none)
            }
        }
    }
    
    internal func addFailedMessages(chatList: Array<CoinliveChatSDK.Chat>) {
        if self.messageList.count == 0 {
            self.messageList.append(contentsOf: chatList) // first가 가장 하단
            self.tvMessages?.reloadData()
        } else {
            var paths: [IndexPath] = []
            
            for i in 0..<chatList.count {
                paths.append(IndexPath(row: i, section: 0))
            }
            
            self.messageList.insert(contentsOf: chatList.reversed(), at: 0)
            UIView.performWithoutAnimation {
                self.tvMessages?.insertRows(at: paths, with: .none)
                self.tvMessages?.scrollToRow(at: IndexPath(row: chatList.count, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    internal func addFailedMessage(chat: Chat) {
        self.messageList.append(chat)
        let row = self.messageList.count - 1
        let section = 0
        let indexPath = IndexPath(row: row, section: section)
        
        UIView.performWithoutAnimation {
            self.tvMessages?.insertRows(at:[indexPath], with: .none)
            self.tvMessages?.reloadRows(at: getNearRows(chat: chat, targetIndex: row), with: .none)
        }
        self.scrollToBottom()
    }
    
    internal func addNewMessage(chat: CoinliveChatSDK.Chat, heightGapOfContent: CGFloat) {
        let isScroll = self.getCurrentYOffset(height: heightGapOfContent)

        self.messageList.append(chat)
        var row = self.messageList.count - 1
        // TODO faild message
        
        if self.messageList.count > 0 {
            for i in stride(from: (self.messageList.count - 1), to: 0, by: -1) {
                if i < 0 {
                    break
                }
                let item = self.messageList[i]
                if item.insertTime == 0 && item.serverTimestamp == nil {
                    row = row + 1
                } else {
                    break
                }
            }
        }
        
        let indexPath = IndexPath(row: row, section: 0)

        UIView.performWithoutAnimation {
            self.tvMessages?.insertRows(at:[indexPath], with: .none)
            self.tvMessages?.reloadRows(at: getNearRows(chat: chat, targetIndex: row), with: .none)
        }
//
        if isScroll {
            self.scrollToBottom()
        } else {
            if !self.isBottomOffset {
                self.isNewMessageShow = true
                var radius = self.newMessageProfileImageSize / 2.0
                if let isNft = chat.isNFTProfile {
                    if isNft {
                        radius = self.newMessageProfileImageSize / 3.0
                    }
                }
                if let sUrl = chat.profileUrl, let url = NSURL(string: sUrl) {
                    ImageCache.shared.load(url: url, completion: { [weak self] (fetchImage) in
                        guard let self = self else { return }
                        guard let fetchImage = fetchImage else {
                            DispatchQueue.main.async {
                                self.ivNewMessageProfile?.layer.cornerRadius = radius
                                self.ivNewMessageProfile?.image = .baseProfile
                            }
                            return
                        }
                        let resizeImage: UIImage  = fetchImage.resizeWithWidth(newWidth: 24)
                        DispatchQueue.main.async {
                            self.ivNewMessageProfile?.layer.cornerRadius = radius
                            self.ivNewMessageProfile?.image = resizeImage
                        }
                    })
                } else if chat.messageType == MESSAGE_TYPE.BUY.name || chat.messageType == MESSAGE_TYPE.SELL.name {
                    self.ivNewMessageProfile?.image = .binance
                    self.lbNewMessageNickname?.text = chat.symbol
                } else if chat.messageType == MESSAGE_TYPE.TWITTER.name {
                    self.ivNewMessageProfile?.image = .twitter
                    self.lbNewMessageNickname?.text = chat.symbol
                } else if chat.messageType == MESSAGE_TYPE.MEDIUM.name {
                    self.ivNewMessageProfile?.image = .medium
                    self.lbNewMessageNickname?.text = chat.symbol
                } else {
                    DispatchQueue.main.async {
                        self.ivNewMessageProfile?.layer.cornerRadius = radius
                        self.ivNewMessageProfile?.image = .baseProfile
                    }
                }

                self.lbNewMessageNickname?.text = chat.userNickname
                self.lbNewMessageNickname?.adjustsFontSizeToFitWidth = true
                self.lbNewMessageNickname?.sizeToFit()
                if chat.images != nil {
                    self.lbNewMessageContent?.text = "new_message_image".localized()
                } else if chat.asset != nil {
                    self.lbNewMessageContent?.text = "new_message_asset".localized(with: [chat.userNickname])
                }
                if let message = chat.koMessage {
                    if message.isCoinMatches() {
                        self.lbNewMessageContent?.text = message.toCoinMatches()
                    } else if message.isUserMatches() {
                        self.lbNewMessageContent?.text = message.toUserMatches()
                    } else {
                        self.lbNewMessageContent?.text = message
                    }
                }

                self.checkDropView()
            }
        }
    }
    
    private func getNearRows(chat: Chat, targetIndex: Int) -> [IndexPath] {
        var newIndexPaths: [IndexPath] = []
        if targetIndex > 0 {
            for i in stride(from: (targetIndex - 1), to: 0, by: -1) {
                if i < 0 {
                    break
                }
                let item = self.messageList[i]
                if item.insertTime.gapOfTimestampByMinute(target: chat.insertTime) {
                    newIndexPaths.append(IndexPath(row: i, section: 0))
                } else {
                    break
                }
            }
        }
        
        if targetIndex < self.messageList.count {
            for i in targetIndex..<self.messageList.count {
                if i > self.messageList.count {
                    break
                }
                let item = self.messageList[i]
                if item.insertTime.gapOfTimestampByMinute(target: chat.insertTime) {
                    newIndexPaths.append(IndexPath(row: i, section: 0))
                } else {
                    break
                }
            }
        }
        return newIndexPaths
    }
    
    private func scrollToIndexPath(section: Int, row: Int, isAnimate: Bool) {
        let indexPath = IndexPath(row: row, section: section)
        self.tvMessages?.scrollToRow(at: indexPath, at: .bottom, animated: isAnimate)
    }
    
    @objc func dropDown() {
        self.scrollToBottom()
    }
    
    @objc func handleRefreshControl() {
        messageTableViewDelegate?.fetchOlderMessages()
    }
    
    private func hideTopIndicator() {
        DispatchQueue.main.async {
            self.tvMessages?.refreshControl?.endRefreshing()
        }
    }
    
    private func checkDropView() {
        guard let btnDown = self.btnDown, let vNewMessage = self.vNewMessage else { return }
        if self.isBottomOffset {
            btnDown.isHidden = true
            vNewMessage.isHidden = true
            self.isNewMessageShow = false
        } else {
            if !self.isNewMessageShow {
                if btnDown.isHidden {
                    vNewMessage.isHidden = true
                    btnDown.isHidden = false
                }
            } else {
                if vNewMessage.isHidden {
                    vNewMessage.isHidden = false
                    btnDown.isHidden = true
                }
            }
        }
    }
}

extension MessageTableView: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tvMessages = self.tvMessages else { return }
        self.isBottomOffset = (tvMessages.contentOffset.y + tvMessages.frame.size.height) > (tvMessages.contentSize.height - 20)
        self.emojiBottomOffset = (tvMessages.contentOffset.y + tvMessages.frame.size.height) > (tvMessages.contentSize.height - 40)
        self.checkDropView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastIndex = (messageList.count == 0 ? 0 : messageList.count - 1)
        
        var isSameDatePreviousMessage: Bool = false
        var isSameDatePostMessage: Bool = false
        var isSameUserPreviousMessage: Bool = false
        var isSameUserPostMessage: Bool = false
        var isBlockUser: Bool = false
        var isSameDayPreviousMessage: Bool = false
        let message = messageList[indexPath.row]
        isBlockUser = self.blockMemberIdList.contains(message.memberId ?? "")
        
        let previousMessage: Chat? = indexPath.row == 0 ? nil : messageList[indexPath.row - 1]
        let postMessage: Chat? = indexPath.row == lastIndex ? nil : messageList[indexPath.row + 1]
        let isMine: Bool = (message.memberId ?? "") == self.customerUser?.memberId
        
        if let previousMessage = previousMessage {
            isSameUserPreviousMessage = message.memberId == previousMessage.memberId
            isSameDatePreviousMessage = message.insertTime.gapOfTimestampByMinute(target: previousMessage.insertTime)
            isSameDayPreviousMessage = message.insertTime.convertTableKey() == previousMessage.insertTime.convertTableKey()
        }
        
        if let postMessage = postMessage {
            isSameUserPostMessage = message.memberId == postMessage.memberId
            isSameDatePostMessage = message.insertTime.gapOfTimestampByMinute(target: postMessage.insertTime)
        }
        
        switch message.messageType.lowercased() {
        case MESSAGE_TYPE.USER.name, MESSAGE_TYPE.USER_RP.name, MESSAGE_TYPE.USER_COUNT.name, MESSAGE_TYPE.ADMIN.name, MESSAGE_TYPE.ADMIN_RP.name, MESSAGE_TYPE.CM.name, MESSAGE_TYPE.CM_RP.name, "":
            if isMine {
                if let urls = message.images {
                    let myImageMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "MyImageMessageCell", for: indexPath) as! MyImageMessageCell
                    myImageMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, memberId: self.customerUser?.memberId)
                    myImageMessageCell.floatMenuDelegate = self.floatMenuDelegate
                    myImageMessageCell.messageCellDelegate = self
                    if let sUrl = urls.first, let url = NSURL(string: sUrl) {
                        ImageCache.shared.load(url: url, completion: { (fetchImage) in
                            guard let fetchImage = fetchImage else {
                                DispatchQueue.main.async {
                                    if let _ = tableView.cellForRow(at: indexPath) {
                                        myImageMessageCell.loadFailed()
                                    }
                                }
                                return
                            }
                            let resizeImage: UIImage
                            if fetchImage.size.width > fetchImage.size.height {
                                resizeImage = fetchImage.resizeWithWidth(newWidth: 1440)
                                DispatchQueue.main.async {
                                    myImageMessageCell.resizeImageViewHeight(image: resizeImage, height: resizeImage.size.height)
                                }
                            } else {
                                resizeImage = fetchImage.resizeWithHeight(newHeight: 1440)
                                DispatchQueue.main.async {
                                    myImageMessageCell.resizeImageViewWidth(image: resizeImage, width: resizeImage.size.width)
                                }
                            }
                        })
                    } else {
                        DispatchQueue.main.async {
                            if let _ = tableView.cellForRow(at: indexPath) {
                                myImageMessageCell.loadFailed()
                            }
                        }
                    }
                    return myImageMessageCell
                } else {
                    let myMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
                    myMessageCell.messageCellDelegate = self
                    myMessageCell.floatMenuDelegate = self.floatMenuDelegate
                    myMessageCell.failedMessageDelegate = self
                    myMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, isMine: isMine, memberId: self.customerUser?.memberId)
                    return myMessageCell
                }
            } else {
                if let urls = message.images {
                    if urls.count > 1 {
                        let userMultiImageMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "UserMultiImageMessageCell") as! UserMultiImageMessageCell
                        userMultiImageMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, isBlockUser: isBlockUser, memberId: self.customerUser?.memberId)
                        userMultiImageMessageCell.floatMenuDelegate = self.floatMenuDelegate
                        userMultiImageMessageCell.messageCellDelegate = self
                        return userMultiImageMessageCell
                    } else {
                        let userImageMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "UserImageMessageCell", for: indexPath) as! UserImageMessageCell
                        userImageMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, isBlockUser: isBlockUser, memberId: self.customerUser?.memberId)
                        userImageMessageCell.floatMenuDelegate = self.floatMenuDelegate
                        userImageMessageCell.messageCellDelegate = self
                        if !isBlockUser {
                            if let sUrl = urls.first, let url = NSURL(string: sUrl) {
                                ImageCache.shared.load(url: url, completion: { (fetchImage)  in
                                    guard let fetchImage = fetchImage else {
                                        DispatchQueue.main.async {
                                            userImageMessageCell.loadFailed()
                                        }
                                        return
                                    }
                                    let resizeImage: UIImage
                                    if fetchImage.size.width > fetchImage.size.height {
                                        resizeImage = fetchImage.resizeWithWidth(newWidth: 1440)
                                        DispatchQueue.main.async {
                                            userImageMessageCell.resizeImageViewHeight(image: resizeImage, height: resizeImage.size.height)
                                            tableView.beginUpdates()
                                            tableView.endUpdates()
                                        }
                                    } else {
                                        resizeImage = fetchImage.resizeWithHeight(newHeight: 1440)
                                        DispatchQueue.main.async {
                                            userImageMessageCell.resizeImageViewWidth(image: resizeImage, width: resizeImage.size.width)
                                            tableView.beginUpdates()
                                            tableView.endUpdates()
                                        }
                                    }
                                })
                            } else {
                                DispatchQueue.main.async {
                                    if let _ = tableView.cellForRow(at: indexPath) {
                                        userImageMessageCell.loadFailed()
                                    }
                                }
                            }
                        }
                        
                        return userImageMessageCell
                    }
                } else {
                    let userMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "UserMessageCell", for: indexPath) as! UserMessageCell
                    userMessageCell.messageCellDelegate = self
                    userMessageCell.floatMenuDelegate = self.floatMenuDelegate
                    userMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, isBlockUser: isBlockUser, memberId: self.customerUser?.memberId)
                    return userMessageCell
                }
            }
        case MESSAGE_TYPE.ASSET.name:
            if isMine {
                let a = UITableViewCell()
                return a
            } else {
                let userAssetMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "UserAssetMessageCell", for: indexPath) as! UserAssetMessageCell
                userAssetMessageCell.messageCellDelegate = self
                userAssetMessageCell.floatMenuDelegate = self.floatMenuDelegate
                userAssetMessageCell.loadData(chat: message, isHideDate: (isSameUserPostMessage && isSameDatePostMessage), isHeadMessage: (!isSameUserPreviousMessage || !isSameDatePreviousMessage), isFirstMessage: indexPath.row == 0, isSameDayPreviousMessage: isSameDayPreviousMessage, isBlockUser: isBlockUser, memberId: self.customerUser?.memberId)
                return userAssetMessageCell
            }
            /// SERVER MESSAGE CELL
        case MESSAGE_TYPE.BUY.name, MESSAGE_TYPE.SELL.name, MESSAGE_TYPE.DROP.name, MESSAGE_TYPE.JUMP.name, MESSAGE_TYPE.MEDIUM.name, MESSAGE_TYPE.TWITTER.name:
            let serverMessageCell = self.tvMessages!.dequeueReusableCell(withIdentifier: "ServerMessageCell", for: indexPath) as! ServerMessageCell
            serverMessageCell.loadData(chat: message, isSameDayPreviousMessage: isSameDayPreviousMessage, channel: channel)
            return serverMessageCell
        default:
            let a = UITableViewCell()
            a.backgroundColor = .black
            return a
        }
    }
}

extension MessageTableView: MessageCellDelegate {
    func clickAllMessage(message: String, isMine: Bool, isTranslate: Bool) {
        self.messageTableViewDelegate?.showDetailTextViewController(message: message, isMine: isMine, isTranslate: isTranslate)
    }
    
    func clickUserProfile(userNickname: String?, profileImage: String?, isNft: Bool?, exchange: String?) {
        self.messageTableViewDelegate?.showUserProfileBottomSheet(userNickname: userNickname, profileImage: profileImage, isNft: isNft, exchange: exchange)
    }
    
    func deleteMessage(chat: Chat) {
        self.messageTableViewDelegate?.deleteMessage(chat: chat)
    }
    
    func blockMessage(memberId: String, isBlock: Bool) {
        self.messageTableViewDelegate?.blockMessage(memberId: memberId, isBlock: isBlock)
    }
    
    func addEmoji(chat: Chat, emojiType: EMOJI_TYPE) {
        self.messageTableViewDelegate?.addEmoji(chat: chat, emojiType: emojiType)
    }
    
    func deleteEmoji(chat: Chat, emojiType: EMOJI_TYPE) {
        self.messageTableViewDelegate?.deleteEmoji(chat: chat, emojiType: emojiType)
    }
}

extension MessageTableView: FailedMessageDelegate {
    private func removeFailedMessage(chat: Chat) {
        if let targetIndex = self.messageList.firstIndex(where: { target in target.messageId == chat.messageId }) {
            self.messageList.remove(at: targetIndex)
            UIView.performWithoutAnimation {
                self.tvMessages?.deleteRows(at: [IndexPath(row: targetIndex, section: 0)], with: .none)
                self.tvMessages?.reloadRows(at: getNearRows(chat: chat, targetIndex: targetIndex), with: .none)
            }
        }
    }
    
    func cancel(chat: Chat) {
        self.removeFailedMessage(chat: chat)
        self.messageTableViewDelegate?.deleteFailedMessage(chat: chat)
    }
    
    func resend(chat: Chat) {
        self.removeFailedMessage(chat: chat)
        self.messageTableViewDelegate?.retryFailedMessage(chat: chat)
    }
}
