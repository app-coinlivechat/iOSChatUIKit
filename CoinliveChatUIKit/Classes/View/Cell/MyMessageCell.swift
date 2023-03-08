//
//  MyMessageView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//


import UIKit
import CoinliveChatSDK

class MyMessageCell: UITableViewCell {
    internal weak var messageCellDelegate: MessageCellDelegate?
    internal weak var failedMessageDelegate: FailedMessageDelegate?
    internal weak var floatMenuDelegate: FloatMenuDelegate?
    private var chat: Chat!
    private var isMine: Bool = false
    private weak var lbDate: UILabel?
    private weak var tvContent: UITextView?
    private weak var ivTranslateBy: UIImageView?
    private weak var vShowAll: UIView?
    private weak var btnResend: UIButton?
    private weak var btnCancel: UIButton?
    private weak var emojiView: EmojiView?
    private weak var messageDateView: MessageDateView?
    
    private var byGoogleWidth: CGFloat = 86.0
    private var byGoogleHeight: CGFloat = 12.0
    private var vShowAllHeight: CGFloat = 36.0
    private var showAllArrowImageSize: CGFloat = 16.0
    private weak var contentTopConstraint: NSLayoutConstraint? = nil
    private weak var contentBottomConstraint: NSLayoutConstraint? = nil
    private weak var vShowAllHeightContraint: NSLayoutConstraint? = nil
    private weak var emojiBottomConstraint: NSLayoutConstraint? = nil
    private weak var svEmojiViewHeightConstraint: NSLayoutConstraint? = nil
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    private var isHeadMessage: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func initializeUi() {
        backgroundColor = .background
        selectionStyle = .none
        
        let messageDateView = MessageDateView()
        messageDateView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageDateView)
        self.messageDateView = messageDateView
        
        let lbDate = UILabel()
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.font = UIFont.systemFont(ofSize: 12)
        lbDate.textColor = .labelMessageDate
        lbDate.textAlignment = .left
        self.contentView.addSubview(lbDate)
        self.lbDate = lbDate
        
        let tvContent = UITextView()
        tvContent.isEditable = false
        tvContent.isScrollEnabled = false
        tvContent.isUserInteractionEnabled = true
        tvContent.translatesAutoresizingMaskIntoConstraints = false
        tvContent.textColor = .white
        tvContent.font = UIFont.systemFont(ofSize: 14)
        tvContent.textContainerInset = .init(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        tvContent.backgroundColor = .primary
        tvContent.dataDetectorTypes = .link
        
        if let actualRecognizers = tvContent.gestureRecognizers {
            for recognizer in actualRecognizers {
                if recognizer.isKind(of: UILongPressGestureRecognizer.self) {
                    recognizer.isEnabled = false
                }
            }
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        longPress.minimumPressDuration = 0.5
        tvContent.addGestureRecognizer(longPress)
        
        self.contentView.addSubview(tvContent)
        self.tvContent = tvContent
        
        let emojiView = EmojiView()
        emojiView.emojiViewDelegate = self
        self.contentView.addSubview(emojiView)
        
        self.emojiView = emojiView
        
        let vShowAll = UIView()
        vShowAll.translatesAutoresizingMaskIntoConstraints = false
        vShowAll.roundCorners(cornerRadius: 16.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        vShowAll.backgroundColor = .primary
        vShowAll.isUserInteractionEnabled = true
        vShowAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickShowAll(_:))))
        
        let lbShowAll = UILabel()
        lbShowAll.translatesAutoresizingMaskIntoConstraints = false
        lbShowAll.text = "notification_board_show_all".localized()
        lbShowAll.textColor = .white
        lbShowAll.font = UIFont.systemFont(ofSize: 12.0)
        vShowAll.addSubview(lbShowAll)
        
        let ivShowAll = UIImageView()
        ivShowAll.translatesAutoresizingMaskIntoConstraints = false
        ivShowAll.image = .rightArrowWhite
        vShowAll.addSubview(ivShowAll)
        
        let btnResend = UIButton(type: .custom)
        btnResend.translatesAutoresizingMaskIntoConstraints = false
        btnResend.backgroundColor = .backgroundFailedMessageController
        btnResend.setImage(.resend, for: .normal)
        btnResend.roundCorners(cornerRadius: 11, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        btnResend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resendMessage)))
        btnResend.isHidden = true
        self.addSubview(btnResend)
        self.btnResend = btnResend
        
        
        let btnCancel = UIButton(type: .custom)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.backgroundColor = .backgroundFailedMessageController
        btnCancel.setImage(.resendCancel, for: .normal)
        btnCancel.roundCorners(cornerRadius: 11, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        btnCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resendCancelMessage)))
        btnCancel.isHidden = true
        self.addSubview(btnCancel)
        self.btnCancel = btnCancel
        
        NSLayoutConstraint.activate([
            lbShowAll.leadingAnchor.constraint(equalTo: vShowAll.leadingAnchor, constant: 12.0),
            lbShowAll.centerYAnchor.constraint(equalTo: vShowAll.centerYAnchor),
            
            ivShowAll.trailingAnchor.constraint(equalTo: vShowAll.trailingAnchor, constant: -12.0),
            ivShowAll.centerYAnchor.constraint(equalTo: vShowAll.centerYAnchor),
            ivShowAll.widthAnchor.constraint(equalToConstant: self.showAllArrowImageSize),
            ivShowAll.heightAnchor.constraint(equalToConstant: self.showAllArrowImageSize)
        ])
        self.contentView.addSubview(vShowAll)
        self.vShowAll = vShowAll
        
        NSLayoutConstraint.activate([
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            tvContent.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),
            tvContent.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
            tvContent.topAnchor.constraint(equalTo: messageDateView.bottomAnchor),
            
            lbDate.trailingAnchor.constraint(equalTo: tvContent.leadingAnchor, constant: -4.0),
            lbDate.bottomAnchor.constraint(equalTo: tvContent.bottomAnchor),
            
            vShowAll.leadingAnchor.constraint(equalTo: tvContent.leadingAnchor),
            vShowAll.bottomAnchor.constraint(equalTo: tvContent.bottomAnchor),
            vShowAll.trailingAnchor.constraint(equalTo: tvContent.trailingAnchor),
            
            emojiView.trailingAnchor.constraint(equalTo: tvContent.trailingAnchor),
            
            btnResend.widthAnchor.constraint(equalToConstant: 24),
            btnResend.heightAnchor.constraint(equalToConstant: 22),
            btnCancel.widthAnchor.constraint(equalToConstant: 24),
            btnCancel.heightAnchor.constraint(equalToConstant: 22),
            
            btnCancel.trailingAnchor.constraint(equalTo: btnResend.leadingAnchor),
            btnCancel.bottomAnchor.constraint(equalTo: btnResend.bottomAnchor),
            btnResend.trailingAnchor.constraint(equalTo: tvContent.leadingAnchor, constant: -4.0),
            btnResend.bottomAnchor.constraint(equalTo: tvContent.bottomAnchor)
        ])
        
        self.contentTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        self.contentBottomConstraint = tvContent.bottomAnchor.constraint(equalTo: emojiView.topAnchor, constant: -4.0)
        self.emojiBottomConstraint = emojiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0.0)
        self.svEmojiViewHeightConstraint = emojiView.heightAnchor.constraint(equalToConstant: 23)
        self.vShowAllHeightContraint = vShowAll.heightAnchor.constraint(equalToConstant: self.vShowAllHeight)
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        
        self.contentTopConstraint?.isActive = true
        self.vShowAllHeightContraint?.isActive = true
        self.contentBottomConstraint?.isActive = true
        self.emojiBottomConstraint?.isActive = true
        self.svEmojiViewHeightConstraint?.isActive = true
        self.dateViewHeightConstraint?.isActive = true
    }
    
    @objc func pressContent(_ recogizer: UILongPressGestureRecognizer) {
        guard let tvContent = self.tvContent else { return }
        if recogizer.state == .began {
            self.floatMenuDelegate?.pressKeyboardCheck { [weak self] in
                guard let self = self else { return }
                let point = CGPoint(x: self.frame.origin.x + tvContent.frame.origin.x, y: self.frame.origin.y + tvContent.frame.origin.y)
                if let convertPoint = self.superview?.convert(point, to: nil) {
                    self.floatMenuDelegate?.loadTextMenu(floatMenuActionDelegate: self,
                                                         position: convertPoint,
                                                         isHeadMessage: self.isHeadMessage, isMyMessage: true, size: tvContent.frame.size, chat: self.chat, isBlockUser: false)
                }
            }
        }
    }
    
    @objc func resendMessage(_ sender: UITapGestureRecognizer) {
        self.failedMessageDelegate?.resend(chat: self.chat)
    }
    
    @objc func resendCancelMessage(_ sender: UITapGestureRecognizer) {
        self.failedMessageDelegate?.cancel(chat: self.chat)
    }
    
    @objc func clickShowAll(_ sender: UITapGestureRecognizer) {
        self.messageCellDelegate?.clickAllMessage(message: self.chat.koMessage ?? "", isMine: self.isMine, isTranslate: false)
    }
    
    internal func loadData(chat: Chat, isHideDate: Bool, isHeadMessage: Bool, isFirstMessage: Bool, isSameDayPreviousMessage: Bool, isMine: Bool, memberId: String?) {
        self.chat = chat
        self.isMine = isMine
        self.isHeadMessage = isHeadMessage
        if isSameDayPreviousMessage {
            self.messageDateView?.isHidden = true
            self.dateViewHeightConstraint?.constant = 0.0
        } else {
            self.messageDateView?.setUpData(date: chat.insertTime.convertTableKey())
            self.messageDateView?.isHidden = false
            self.dateViewHeightConstraint?.constant = 52.0
        }
        
        if chat.insertTime == 0 && chat.serverTimestamp == nil { // 실패 메세지
            self.contentTopConstraint?.constant = 0.0
            self.tvContent?.clipsToBounds = true
            self.tvContent?.layer.cornerRadius = 16.0
            self.tvContent?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.lbDate?.isHidden = true
            self.btnCancel?.isHidden = false
            self.btnResend?.isHidden = false
            self.svEmojiViewHeightConstraint?.constant = 0.0
            self.emojiView?.isHidden = true
            self.emojiView?.hideEmoji()
            self.emojiBottomConstraint?.constant = 0.0
        } else {
            self.btnCancel?.isHidden = true
            self.btnResend?.isHidden = true
            if isHeadMessage {
                self.contentTopConstraint?.constant = 4.0
                self.tvContent?.clipsToBounds = true
                self.tvContent?.layer.cornerRadius = 16.0
                self.tvContent?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                self.contentTopConstraint?.constant = 0.0
                self.tvContent?.clipsToBounds = true
                self.tvContent?.layer.cornerRadius = 16.0
                self.tvContent?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
            
            if let emojis = chat.emoji {
                if emojis.count > 0 {
                    if emojis.values.contains(where: { emoji in emoji.count > 0}) {
                        self.emojiBottomConstraint?.constant = -4.0
                        self.svEmojiViewHeightConstraint?.constant = 23.0
                        self.emojiView?.isHidden = false
                        self.emojiView?.loadEmoji(emojis: emojis, memberId: memberId ?? "")
                    } else {
                        self.emojiBottomConstraint?.constant = 0.0
                        self.svEmojiViewHeightConstraint?.constant = 0.0
                        self.emojiView?.isHidden = true
                        self.emojiView?.hideEmoji()
                    }
                } else {
                    self.svEmojiViewHeightConstraint?.constant = 0.0
                    self.emojiView?.isHidden = true
                    self.emojiView?.hideEmoji()
                    self.emojiBottomConstraint?.constant = 0.0
                }
            } else {
                self.svEmojiViewHeightConstraint?.constant = 0.0
                self.emojiView?.isHidden = true
                self.emojiView?.hideEmoji()
                self.emojiBottomConstraint?.constant = 0.0
            }
            
            self.lbDate?.isHidden = isHideDate
            if !isHideDate {
                self.lbDate?.text = chat.insertTime.convertDateFormat(form: "a hh:mm", locale: .current)
            }
        }
        
        if let message = chat.koMessage {
            if message.count > 400 {
                self.tvContent?.text = message.prefix(397).appending("...\n\n")
                self.vShowAll?.isHidden = false
                self.vShowAllHeightContraint?.constant = self.vShowAllHeight
            } else {
                self.tvContent?.text = message
                self.vShowAll?.isHidden = true
                self.vShowAllHeightContraint?.constant = 0
            }
        }
    }
}

extension MyMessageCell: FloatMenuActionDelegate {
    func deleteEmojiAction(_ emojiType: EMOJI_TYPE) {
        // no
    }
    
    func emojiAction(_ emojiType: EMOJI_TYPE) {
        // no
    }
    
    func copy() {
        UIPasteboard.general.string = self.chat.koMessage
    }
    
    func cancel() {
        
    }
    
    func block() {
        
    }
    
    func delete() {
        self.messageCellDelegate?.deleteMessage(chat: self.chat)
    }
    
    func report() {
        
    }
}

extension MyMessageCell: EmojiViewDelegate {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool) {
        // no!
    }
}
