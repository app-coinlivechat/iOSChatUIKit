//
//  ChatViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/11.
//

import UIKit
import CoinliveChatSDK

public class CoinliveChatViewController: UIViewController {
    private let baseToolbarSize: CGFloat = 60.0
    private var vHeightInputView: CGFloat = 56.0
    private weak var appbarView: AppbarView?
    private weak var chatInputView: InputView?
    private var lbAmaHeightConstraint: NSLayoutConstraint? = nil
    private var vInputViewHeightConstraint: NSLayoutConstraint? = nil
    private var vInputViewBottomConstraint: NSLayoutConstraint? = nil
    private var noticeViewHeightConstraint: NSLayoutConstraint? = nil
    private var noticeViewWidthConstraint: NSLayoutConstraint? = nil
    private var noticeViewleadingConstraint: NSLayoutConstraint? = nil
    private var noticeViewtrailingConstraint: NSLayoutConstraint? = nil
    private var noticeViewTopConstraint: NSLayoutConstraint? = nil
    private weak var tvMessages: MessageTableView?
    private weak var vNotice: NoticeView?
    private weak var lbAma: UILabel?
    
    public var channel: Channel!
    public var customerName: String!
    public var customerUser: CustomerUser?
    private var coinliveChatViewModel: CoinliveChatViewModel!
    private var isFirstInit = true
    private var menuAlertCallback: (() -> ())? = nil
    private var appDidEnterBackgroundDate: Date? = nil
    private weak var menuViewDelegate: MenuViewDelegate? = nil
    private var vMenuBackgroundView: UIView? = nil
    private var pressMessageCallback: (() -> ())? = nil
    private var isShowingKeyboard: Bool = false
    private var keyboardFrameHeight: CGFloat = 0.0
    private var limitSendTimer: Timer?
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let controllerTapDismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(controllerTapDismissKeyboardGesture)
        
        initializeViewModel()
        initializeSystemUi()
        initializeUi()
        self.coinliveChatViewModel.loadChatData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coinliveChatViewModel.chatRoomJoin()
    }
    
    deinit {
        ImageCache.shared.clearAll()
    }
    
    public override func viewWillDisappear(_ animate: Bool) {
        super.viewWillDisappear(animate)
        self.coinliveChatViewModel.close()
        NotificationCenter.default.removeObserver(self)
        self.chatInputView?.close()
        self.limitSendTimer?.invalidate()
        self.limitSendTimer = nil
        self.chatInputView = nil
        self.appbarView?.close()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.chatInputView?.endEditInputView()
        self.appbarView?.close()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.isShowingKeyboard = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardFrameHeight = keyboardHeight
            self.keyboardShowEvent(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.isShowingKeyboard = false
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardFrameHeight = 0.0
            self.keyboardHideEvent(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        self.isShowingKeyboard = false
        if let messagePressCallback = self.pressMessageCallback {
            self.pressMessageCallback = nil
            self.keyboardFrameHeight = 0.0
            messagePressCallback()
        }
    }
    
    private func initializeUi() {
        self.view.backgroundColor = .background
        
        let appbarView = AppbarView()
        appbarView.isAnonymousUser = self.customerUser == nil
        appbarView.setUpData(channel: channel!, appbarActionDelegate: self)
        self.coinliveChatViewModel.chatUserCountDelegate = appbarView
        appbarView.appbarActionDelegate = self
        self.view.addSubview(appbarView)
        let divider = CALayer()
        divider.backgroundColor = UIColor.headerDivider.cgColor
        divider.frame = CGRect(origin: CGPointMake(0, (self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize) - 1), size: CGSize(width: self.view.frame.size.width, height: 1))
        appbarView.layer.addSublayer(divider)
        
        self.appbarView = appbarView
        
        
        let tvMessages = MessageTableView()
        tvMessages.setUpData(customerUser: self.customerUser, channel: self.channel, messageTableViewDelegate: self)
        tvMessages.floatMenuDelegate = self
        if let customerUser = self.customerUser {
            tvMessages.addBlockMemberIdList(list: customerUser.blockList)
        }
        self.view.addSubview(tvMessages)
        self.tvMessages = tvMessages
        
        let vNotice = NoticeView()
        vNotice.translatesAutoresizingMaskIntoConstraints = false
        vNotice.noticeActionDelegate = self
        self.view.addSubview(vNotice)
        self.vNotice = vNotice
        
        let lbAma = UILabel()
        lbAma.translatesAutoresizingMaskIntoConstraints = false
        lbAma.isHidden = true
        lbAma.layer.cornerRadius = 14
        lbAma.clipsToBounds = true
        lbAma.textAlignment = .center
        self.view.addSubview(lbAma)
        self.lbAma = lbAma
        
        let chatInputView = InputView()
        
        chatInputView.setUpData(inputViewDelegate: self, isAnonymousUser: self.customerUser == nil)
        self.view.addSubview(chatInputView)
        let vDivider = UIView()
        vDivider.backgroundColor = .headerDivider
        vDivider.translatesAutoresizingMaskIntoConstraints = false
        chatInputView.addSubview(vDivider)
        
        self.chatInputView = chatInputView
        
        NSLayoutConstraint.activate([
            appbarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            appbarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            appbarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            appbarView.heightAnchor.constraint(equalToConstant: self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize),
            
            tvMessages.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tvMessages.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tvMessages.topAnchor.constraint(equalTo: appbarView.bottomAnchor),
            tvMessages.bottomAnchor.constraint(equalTo: chatInputView.topAnchor),
            
            lbAma.widthAnchor.constraint(equalToConstant: 82),
            lbAma.topAnchor.constraint(equalTo: vNotice.bottomAnchor, constant: 10.0),
            lbAma.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -6.0),
            
            chatInputView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            vDivider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            vDivider.topAnchor.constraint(equalTo: chatInputView.topAnchor),
            vDivider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            vDivider.heightAnchor.constraint(equalToConstant: 1),
            vDivider.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        
        self.noticeViewTopConstraint = vNotice.topAnchor.constraint(equalTo: appbarView.bottomAnchor)
        self.noticeViewleadingConstraint = vNotice.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
        self.noticeViewtrailingConstraint = vNotice.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        self.noticeViewHeightConstraint = vNotice.heightAnchor.constraint(equalToConstant: 0)
        self.noticeViewWidthConstraint = vNotice.widthAnchor.constraint(equalToConstant: 0)
        self.noticeViewleadingConstraint?.isActive = false
        self.noticeViewtrailingConstraint?.isActive = false
        self.noticeViewHeightConstraint?.isActive = true
        self.noticeViewWidthConstraint?.isActive = true
        self.noticeViewTopConstraint?.isActive = true
        
        self.vInputViewBottomConstraint = chatInputView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.vInputViewBottomConstraint?.isActive = true
        self.vInputViewHeightConstraint = chatInputView.heightAnchor.constraint(equalToConstant: self.vHeightInputView)
        self.vInputViewHeightConstraint?.isActive = true
        self.lbAmaHeightConstraint = lbAma.heightAnchor.constraint(equalToConstant: 28)
        self.lbAmaHeightConstraint?.isActive = true
        
        self.view.addSubview(self.indicatorView)
        self.indicatorView.isHidden = true
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func initializeSystemUi() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .background
    }
    
    private func initializeViewModel() {
        self.coinliveChatViewModel = CoinliveChatViewModel(channel: channel, customerUser: customerUser, customerName: customerName, messageDelegate: self, noticeDelegate: self, timeLimitDelegate: self, coinliveChatViewModelDelegate: self)
    }
    
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!
        self.coinliveChatViewModel.backgroundToFront(difference: seconds)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touches.forEach { t in
            if let touchView = t.view as? FloatChatMenuView {
                touchView.closeMenu()
            }
        }
    }
    
    func showActivityIndicator() {
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
}

extension CoinliveChatViewController: MessageDelegate {
    public func deletedMessage(chat: CoinliveChatSDK.Chat?) {
        if let chat = chat {
            self.tvMessages?.deletedMessage(chat: chat)
            self.menuViewDelegate?.deletedMessage(messageId: chat.messageId, callback: { [weak self] isDismiss in
                guard let self = self else { return }
                if isDismiss {
                    self.vMenuBackgroundView?.removeFromSuperview()
                }
            })
        }
    }
    
    public func modifyMessage(chat: CoinliveChatSDK.Chat) {
        self.tvMessages?.updateChat(chat: chat)
    }
    
    public func oldMessages(chatArray: Array<CoinliveChatSDK.Chat>, isReload: Bool) {
        if isReload {
            self.tvMessages?.reloadMessages(chatList: chatArray)
        } else {
            self.tvMessages?.addMessages(chatList: chatArray)
        }
        
    }
    
    public func newMessages(chat: CoinliveChatSDK.Chat) {
        let height = (self.chatInputView?.frame.size.height ?? 0) - self.vHeightInputView
        self.tvMessages?.addNewMessage(chat: chat, heightGapOfContent: height)
    }
    
    public func failSendMessage(chat: CoinliveChatSDK.Chat) {
        self.tvMessages?.addFailedMessage(chat: chat)
    }
    
    public func retrySendMessageSuccess(messageId: String?) {
    }
}

extension CoinliveChatViewController: NoticeDelegate {
    public func cmNoticeListener(notice: String?) {
        if let notice = notice {
            self.vNotice?.showNotice(notice: notice)
            self.vNotice?.isHidden = false
        } else {
            self.vNotice?.isHidden = true
        }
    }
}

extension CoinliveChatViewController: CoinliveChatViewModelDelegate {
    func apiFailedToast(message: String) {
        self.showToast(message: message, font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
    }
    
    func chatStatus(status: USER_STATUS) {
        switch status {
        case .BLOCK, .DORMANT, .INACTIVE:
            self.chatInputView?.changeStatus(isLock: true)
            break
        case .ACTIVE:
            self.chatInputView?.changeStatus(isLock: false)
            break
        case .NONE:
            self.chatInputView?.changeStatus(isLock: true)
            break
        default:
            break
        }
    }
    
    func ama(status: AMA_STATUS) {
        switch status {
        case .NONE:
            DispatchQueue.main.async {
                self.chatInputView?.unBlockInpuText()
                self.lbAma?.isHidden = true
                self.lbAmaHeightConstraint?.constant = 0.0
                self.lbAma?.layoutIfNeeded()
            }
            break
        case .BEFORE:
            DispatchQueue.main.async {
                self.chatInputView?.unBlockInpuText()
                self.lbAma?.backgroundColor = .backgroundAma
                self.lbAmaHeightConstraint?.constant = 28.0
                self.lbAma?.layoutIfNeeded()
            }
            break
        case .DONE:
            DispatchQueue.main.async {
                self.chatInputView?.unBlockInpuText()
                self.lbAma?.attributedText = nil
                self.lbAma?.isHidden = true
                self.lbAmaHeightConstraint?.constant = 0.0
                self.lbAma?.layoutIfNeeded()
            }
        case .LIVE:
            self.chatInputView?.blockInputText()
            let text = "AMA LIVE"
            let attribtuedString = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: attribtuedString.length)
            let range = (text as NSString).range(of: "AMA")
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.white, range: fullRange)
            attribtuedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: fullRange)
            attribtuedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: range)
            
            DispatchQueue.main.async {
                self.lbAma?.backgroundColor = .ama
                self.lbAma?.attributedText = attribtuedString
                self.lbAma?.isHidden = false
                self.lbAmaHeightConstraint?.constant = 28.0
                self.lbAma?.layoutIfNeeded()
            }
        @unknown default:
            fatalError()
        }
    }
    
    func amaTick(day: Int, hour: Int, minute: Int, second: Int) {
        guard let lbAma = self.lbAma else { return }
        var date = ""
        if day > 0 {
            date = "D-\(day)"
        } else if hour > 0 {
            let h = (hour / 10) > 0 ? "\(hour)" : "0\(hour)"
            let m = (minute / 10) > 0 ? "\(minute)" : "0\(minute)"
            date = "\(h):\(m)"
        } else {
            let m = (minute / 10) > 0 ? "\(minute)" : "0\(minute)"
            let s = (second / 10) > 0 ? "\(second)" : "0\(second)"
            date = "\(m):\(s)"
        }
        
        let text = "AMA \(date)"
        let attribtuedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attribtuedString.length)
        let range = (text as NSString).range(of: "AMA")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.ama, range: fullRange)
        attribtuedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: fullRange)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        attribtuedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: range)
        
        DispatchQueue.main.async {
            if lbAma.isHidden {
                lbAma.backgroundColor = .backgroundAma
                lbAma.isHidden = false
                self.lbAmaHeightConstraint?.constant = 28.0
                lbAma.layoutIfNeeded()
            }
            lbAma.attributedText = attribtuedString
        }
    }
    
    func shareChannelUrl(url: String) {
        UIPasteboard.general.string = url
    }
    
    func loadFailedMessages(chats: [Chat]) {
        self.tvMessages?.addFailedMessages(chatList: chats)
    }
}

extension CoinliveChatViewController: AppbarActionDelegate {
    func actionProfileSetting() {
        let editProfileAlertViewController = EditProfileAlertViewController()
        editProfileAlertViewController.modalPresentationStyle = .overFullScreen
        editProfileAlertViewController.nickname = self.customerUser?.nickname
        editProfileAlertViewController.profileUrl = self.customerUser?.profileImage
        editProfileAlertViewController.editProfileDelegate = self
        self.present(editProfileAlertViewController, animated: false)
    }
    
    func actionFold() {
        self.coinliveChatViewModel.close()
        NotificationCenter.default.removeObserver(self)
        self.chatInputView?.close()
        self.chatInputView = nil
        self.appbarView?.close()
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionChannelShare() {
        self.coinliveChatViewModel.copyToChannelLink()
        showToast(message: "toast_copy_url".localized(), font: .systemFont(ofSize: 14), keyboardFrameHeight: self.keyboardFrameHeight)
    }
    
    func actionNotificationSetting() {
        let notificationSettingViewController = NotificationSettingViewController()
        notificationSettingViewController.loadData(notificationSettings: self.coinliveChatViewModel.notificationMap)
        notificationSettingViewController.notificationSettingDelegate = self
        self.navigationController?.pushViewController(notificationSettingViewController, animated: true)
    }
    
    func actionTranslateSetting() {
        self.navigationController?.pushViewController(TranslatorViewController(), animated: true)
    }
}

extension CoinliveChatViewController: InputViewDelegate {
    func changeInputViewHeight(height: CGFloat) {
        self.vHeightInputView = height + 23.0
        self.vInputViewHeightConstraint?.constant = self.vHeightInputView
        UIView.animate(withDuration: 0.1, animations: {
            self.chatInputView?.layoutIfNeeded()
            self.tvMessages?.resizeTableView()
            self.tvMessages?.layoutIfNeeded()
        })
    }
    
    func keyboardShowEvent(keyboardHeight: CGFloat) {
        var bottomPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            bottomPadding = window.safeAreaInsets.bottom
        }
        
        self.vInputViewBottomConstraint?.constant = (-keyboardHeight + bottomPadding)
        UIView.animate(withDuration: 0.1, animations: {
            self.chatInputView?.layoutIfNeeded()
            self.tvMessages?.resizeTableView()
            self.tvMessages?.layoutIfNeeded()
        })
    }
    
    func keyboardHideEvent(keyboardHeight: CGFloat) {
        self.vInputViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.1, animations: {
            self.chatInputView?.layoutIfNeeded()
            self.tvMessages?.resizeTableView()
            self.tvMessages?.layoutIfNeeded()
        })
    }
    
    func sendMessage(message: String) {
        self.coinliveChatViewModel.sendMessage(message: message)
        self.tvMessages?.scrollToBottom()
    }
}

extension CoinliveChatViewController: MessageTableViewDelegate {
    func deleteFailedMessage(chat: Chat) {
        if let messageId = chat.messageId {
            self.coinliveChatViewModel.deleteDatabaseMessage(messageId: messageId)
        }
    }
    
    func retryFailedMessage(chat: Chat) {
        if let koMessage = chat.koMessage, let enMessage = chat.enMessage {
            if koMessage.isEmpty {
                self.coinliveChatViewModel.sendMessage(message: enMessage)
            } else {
                self.coinliveChatViewModel.sendMessage(message: koMessage)
            }
        }
        if let messageId = chat.messageId {
            self.coinliveChatViewModel.deleteDatabaseMessage(messageId: messageId)
        }
    }
    
    func fetchOlderMessages() {
        self.coinliveChatViewModel.loadChatData()
    }
    
    func showDetailTextViewController(message: String, isMine: Bool, isTranslate: Bool) {
        let textViewController = TextViewController()
        textViewController.message = message
        textViewController.isMine = isMine
        textViewController.isTranslate = isTranslate
        self.navigationController?.pushViewController(textViewController, animated: true)
    }
    
    func showUserProfileBottomSheet(userNickname: String?, profileImage: String?, isNft: Bool?, exchange: String?) {
        let profileBottomSheetViewController = ProfileBottomSheetViewController()
        profileBottomSheetViewController.isNft = isNft
        profileBottomSheetViewController.nickname = userNickname
        profileBottomSheetViewController.profileUrl = profileImage
        profileBottomSheetViewController.exchange = exchange
        self.present(profileBottomSheetViewController, animated: true)
    }
    
    func deleteMessage(chat: Chat) {
        self.coinliveChatViewModel.deleteMessage(chat: chat)
    }
    
    func blockMessage(memberId: String, isBlock: Bool) {
        if isBlock {
            self.coinliveChatViewModel.blockUser(memberId: memberId, callback: { list in
                if let list = list {
                    self.tvMessages?.addBlockMemberIdList(list: list)
                } else {
                    self.showToast(message: "Fail", font: .systemFont(ofSize: 14), keyboardFrameHeight: self.keyboardFrameHeight)
                }
            })
        } else {
            self.coinliveChatViewModel.unBlockUser(memberId: memberId, callback: { list in
                if let list = list {
                    self.tvMessages?.addBlockMemberIdList(list: list)
                } else {
                    self.showToast(message: "Fail", font: .systemFont(ofSize: 14), keyboardFrameHeight: self.keyboardFrameHeight)
                }
            })
        }
    }
    
    func addEmoji(chat: Chat, emojiType: EMOJI_TYPE) {
        self.coinliveChatViewModel.addEmoji(chat: chat, emoji: emojiType)
    }
    
    func deleteEmoji(chat: Chat, emojiType: EMOJI_TYPE) {
        self.coinliveChatViewModel.deleteEmoji(chat: chat, emoji: emojiType)
    }
}

extension CoinliveChatViewController: NotificationSettingDelegate {
    func reloadSettings(settings: Dictionary<String, Bool>) {
        self.coinliveChatViewModel.notificationReFetch(notificationMap: settings)
    }
}

extension CoinliveChatViewController: NoticeActionDelegate {
    func foldNotice() {
        self.noticeViewleadingConstraint?.isActive = false
        self.noticeViewtrailingConstraint?.isActive = true
        self.noticeViewWidthConstraint?.isActive = true
        self.noticeViewWidthConstraint?.constant = 38.0
        self.noticeViewtrailingConstraint?.constant = -16.0
        self.noticeViewTopConstraint?.constant = 12.0
        self.noticeViewHeightConstraint?.constant = 38.0
        self.vNotice?.layoutIfNeeded()
    }
    
    func expandNotice(height: CGFloat) {
        self.noticeViewTopConstraint?.constant = 4.0
        self.noticeViewHeightConstraint?.constant = height
        self.vNotice?.layoutIfNeeded()
    }
    
    func collapseNotice() {
        self.noticeViewtrailingConstraint?.isActive = true
        self.noticeViewtrailingConstraint?.constant = -6.0
        self.noticeViewWidthConstraint?.isActive = false
        self.noticeViewTopConstraint?.constant = 4.0
        self.noticeViewHeightConstraint?.constant = 44.0
        self.noticeViewleadingConstraint?.isActive = true
        self.noticeViewleadingConstraint?.constant = 6.0
        self.vNotice?.layoutIfNeeded()
    }
    
    func clickShowAll(message: String) {
        let textViewController = TextViewController()
        textViewController.message = message
        textViewController.isMine = false
        textViewController.isTranslate = false
        textViewController.titleText = "notification_title".localized()
        self.navigationController?.pushViewController(textViewController, animated: true)
    }
}

extension CoinliveChatViewController: FloatMenuDelegate {
    func loadMultiImageMenu(floatMenuActionDelegate: FloatMenuActionDelegate, position: CGPoint, isMyMessage: Bool, images: Array<UIImage>, size: CGSize, chat: CoinliveChatSDK.Chat, isBlockUser: Bool) {
        guard let memberid = self.customerUser?.memberId else { return }
        let vFloatChatMenuView = FloatChatMenuView()
        vFloatChatMenuView.floatMenuActionDelegate = floatMenuActionDelegate
        vFloatChatMenuView.menuViewActionDelegate = self
        self.addFloatView(floatChatMenuView: vFloatChatMenuView)
        vFloatChatMenuView.loadMultiImageMenu(position: position,
                                              images: images,
                                              isMyMessage: isMyMessage,
                                              baseViewHeight: view.frame.size.height,
                                              chat: chat,
                                              size: size,
                                              isBlockUser: isBlockUser,
                                              memberId: memberid)
        self.menuViewDelegate = vFloatChatMenuView
    }
    
    func loadTextMenu(floatMenuActionDelegate: FloatMenuActionDelegate, position: CGPoint, isHeadMessage: Bool, isMyMessage: Bool, size: CGSize, chat: CoinliveChatSDK.Chat, isBlockUser: Bool) {
        let vFloatChatMenuView = FloatChatMenuView()
        vFloatChatMenuView.floatMenuActionDelegate = floatMenuActionDelegate
        vFloatChatMenuView.menuViewActionDelegate = self
        self.addFloatView(floatChatMenuView: vFloatChatMenuView)
        vFloatChatMenuView.loadTextMenu(position: position, isHeadMessage: isHeadMessage, isMyMessage: isMyMessage, size: size, chat: chat, baseViewHeight: view.frame.size.height, isBlockUser: isBlockUser, memberId: self.customerUser?.memberId)
        self.menuViewDelegate = vFloatChatMenuView
    }
    
    func loadAssetMenu(floatMenuActionDelegate: FloatMenuActionDelegate, position: CGPoint, isHeadMessage: Bool, isMyMessage: Bool, size: CGSize, chat: CoinliveChatSDK.Chat, isBlockUser: Bool) {
        guard let memberid = self.customerUser?.memberId else { return }
        let vFloatChatMenuView = FloatChatMenuView()
        vFloatChatMenuView.floatMenuActionDelegate = floatMenuActionDelegate
        vFloatChatMenuView.menuViewActionDelegate = self
        vFloatChatMenuView.loadAssetMenu(position: position, isHeadMessage: isHeadMessage, isMyMessage: isMyMessage, size: size, chat: chat, baseViewHeight: view.frame.size.height, isBlockUser: isBlockUser, memberId: memberid)
        self.addFloatView(floatChatMenuView: vFloatChatMenuView)
        self.menuViewDelegate = vFloatChatMenuView
    }
    
    func loadImageMenu(floatMenuActionDelegate: FloatMenuActionDelegate, position: CGPoint, isMyMessage: Bool, image: UIImage, chat: Chat, isBlockUser: Bool) {
        guard let memberid = self.customerUser?.memberId else { return }
        let vFloatChatMenuView = FloatChatMenuView()
        vFloatChatMenuView.floatMenuActionDelegate = floatMenuActionDelegate
        vFloatChatMenuView.menuViewActionDelegate = self
        vFloatChatMenuView.loadImageMenu(position: position, image: image, isMyMessage: isMyMessage, baseViewHeight: view.frame.size.height, chat: chat, isBlockUser: isBlockUser, memberId: memberid)
        self.addFloatView(floatChatMenuView: vFloatChatMenuView)
        self.menuViewDelegate = vFloatChatMenuView
    }
    
    private func addFloatView(floatChatMenuView: FloatChatMenuView) {
        floatChatMenuView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        
        if let lastWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.vMenuBackgroundView = UIView(frame: lastWindow.bounds)
            if let backgroundView = self.vMenuBackgroundView {
                lastWindow.addSubview(backgroundView)
                backgroundView.layer.zPosition = CGFloat(MAXFLOAT)
                backgroundView.backgroundColor = .black.withAlphaComponent(0.7)
                backgroundView.addSubview(floatChatMenuView)
            }
        }
    }
    
    func pressKeyboardCheck(pressMessageCallback: @escaping () -> ()) {
        if self.isShowingKeyboard {
            self.pressMessageCallback = pressMessageCallback
            self.chatInputView?.endEditInputView()
        } else {
            pressMessageCallback()
        }
    }
}

extension CoinliveChatViewController: MenuViewActionDelegate {
    func showAlert(description: String, confirmText: String, cancelText: String, eCallback: @escaping () -> ()) {
        self.menuAlertCallback = eCallback
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.alertActionDelegate = self
        alert.loadData(descriptionText: description, confirmText: confirmText, cancelText: cancelText, confirmButtonColor: .backgroundPopupRed, cancelButtonColor: .backgroundPopupCancel)
        self.present(alert, animated: false)
    }
    
    func showReportAlert(chat: Chat) {
        self.coinliveChatViewModel.getReportTypes(callback: { types in
            let reportAlertViewController = ReportAlertViewController()
            reportAlertViewController.modalPresentationStyle = .overFullScreen
            reportAlertViewController.reportTypes = types
            reportAlertViewController.reportAlertActionDelegate = self
            reportAlertViewController.reportUserId = chat.memberId
            self.present(reportAlertViewController, animated: false)
        })
    }
    
    func closeMenu() {
        if let backgroundView = self.vMenuBackgroundView {
            DispatchQueue.main.async {
                backgroundView.removeFromSuperview()
            }
        }
    }
}

extension CoinliveChatViewController: AlertActionDelegate {
    func confirm() {
        self.menuAlertCallback?()
    }
    
    func cancel() {
        
    }
}

extension CoinliveChatViewController: ReportAlertActionDelegate {
    func reportConfirm(reportId: String, memberId: String, reportMessage: String) {
        self.coinliveChatViewModel.reportUser(reportMessage: reportMessage, reportMemberId: memberId, reportTypeId: reportId, callback: { isSuccess in
            // TODO toast 신고 성공
            self.showToast(message: "toast_report".localized(), font: .systemFont(ofSize: 14), keyboardFrameHeight: self.keyboardFrameHeight)
        })
    }
    
    func reportCancel() {
        
    }
}

extension CoinliveChatViewController: EditProfileDelegate {
    func cancelEditProfile() {
        
    }
    
    func saveEditProfile(nickname: String?, profileImage: Data?) {
        self.showActivityIndicator()
        if nickname != nil {
            self.coinliveChatViewModel.setNickname(nickname: nickname!, callback: { ( isSuccess, message) in
                if profileImage != nil {
                    self.coinliveChatViewModel.profileImageUpload(data: profileImage!, callback: { isSuccess2, message2 in
                        self.hideActivityIndicator()
                        if !isSuccess && !isSuccess2 {
                            self.showToast(message: "Fail upload", font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
                        } else if !isSuccess {
                            self.showToast(message: message ?? "", font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
                        } else if !isSuccess2 {
                            self.showToast(message: message2 ?? "", font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
                        } else {
                            self.coinliveChatViewModel.loadCustomerUserInfo(callback: { user in
                                self.customerUser = user
                            })
                        }
                    })
                } else {
                    if isSuccess {
                        self.hideActivityIndicator()
                        self.coinliveChatViewModel.loadCustomerUserInfo(callback: { user in
                            self.customerUser = user
                        })
                    } else {
                        self.hideActivityIndicator()
                        self.showToast(message: message ?? "", font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
                    }
                }
            })
        } else if profileImage != nil {
            self.coinliveChatViewModel.profileImageUpload(data: profileImage!, callback: { isSuccess, message in
                self.hideActivityIndicator()
                if isSuccess {
                    self.coinliveChatViewModel.loadCustomerUserInfo(callback: { user in
                        self.customerUser = user
                    })
                } else {
                    self.hideActivityIndicator()
                    self.showToast(message: message ?? "", font: UIFont.systemFont(ofSize: 14.0), keyboardFrameHeight: self.keyboardFrameHeight)
                }
            })
        }
    }
}

extension CoinliveChatViewController: TimeLimitDelegate {
    public func timeLimit(time: Int) {
        if time >= 0 {
            if chatInputView == nil {
                if limitSendTimer == nil {
                    var gap = 0
                    limitSendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                        gap += Int(timer.timeInterval)
                        DispatchQueue.main.async {
                            self?.chatInputView?.blockTimeLimit(time: (time + gap))
                        }
                        timer.invalidate()
                        self?.limitSendTimer = nil
                    })
                    return
                }
            }
            chatInputView?.blockTimeLimit(time: time)
        } else {
            
        }
    }
}
