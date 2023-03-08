//
//  UserMessageView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//


import UIKit
import CoinliveChatSDK

class UserMessageCell: UITableViewCell {
    internal weak var messageCellDelegate: MessageCellDelegate?
    internal weak var floatMenuDelegate: FloatMenuDelegate?
    private var chat: Chat!
    private weak var ivProfile: UIImageView?
    private weak var lbProfileName: UILabel?
    private weak var lbDate: UILabel?
    private weak var tvContent: UITextView?
    private weak var ivTranslateBy: UIImageView?
    private weak var lbAma: PaddingLabel?
    private weak var vShowAll: UIView?
    private weak var emojiView: EmojiView?
    private weak var messageDateView: MessageDateView?
    
    private var profileImageSize: CGFloat = 32.0
    private var vShowAllHeight: CGFloat = 36.0
    private var amaLabelHeight: CGFloat = 14.0
    private var byGoogleWidth: CGFloat = 86.0
    private var byGoogleHeight: CGFloat = 12.0
    private var showAllArrowImageSize: CGFloat = 16.0
    private weak var profileNameHeightConstraint: NSLayoutConstraint?
    private weak var profileTopConstraint: NSLayoutConstraint?
    private weak var contentTopConstraint: NSLayoutConstraint?
    private weak var contentBottomConstraint: NSLayoutConstraint?
    private weak var emojiBottomConstraint: NSLayoutConstraint?
    private weak var vShowAllHeightContraint: NSLayoutConstraint?
    private weak var svEmojiViewHeightConstraint: NSLayoutConstraint?
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    private var isAddedShowAllView: Bool = false
    private var isHeadMessage: Bool = false
    private var isBlockUser: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ivProfile?.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
        
    private func initializeUi() {
        self.backgroundColor = .background
        selectionStyle = .none
        self.isAddedShowAllView = false
        
        let messageDateView = MessageDateView()
        messageDateView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageDateView)
        self.messageDateView = messageDateView
        
        let ivProfile = UIImageView()
        ivProfile.translatesAutoresizingMaskIntoConstraints = false
        ivProfile.layer.cornerRadius = profileImageSize / 2.0
        ivProfile.clipsToBounds = true
        ivProfile.isUserInteractionEnabled = true
        ivProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickProfile)))
        self.contentView.addSubview(ivProfile)
        self.ivProfile = ivProfile
        
        let lbProfileName = UILabel()
        lbProfileName.translatesAutoresizingMaskIntoConstraints = false
        lbProfileName.textColor = .label
        lbProfileName.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(lbProfileName)
        self.lbProfileName = lbProfileName
        
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
        tvContent.textColor = .label
        tvContent.font = UIFont.systemFont(ofSize: 14)
        tvContent.textContainerInset = .init(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        tvContent.backgroundColor = .boxMessage
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
        
        let lbAma = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        lbAma.translatesAutoresizingMaskIntoConstraints = false
        lbAma.layer.borderColor = UIColor.ama.cgColor
        lbAma.layer.borderWidth = 1.0
        lbAma.text = "AMA"
        lbAma.textColor = .ama
        lbAma.font = UIFont.systemFont(ofSize: 9.0)
        lbAma.textAlignment = .center
        lbAma.layer.cornerRadius = amaLabelHeight / 2.0
        lbAma.isHidden = true
        self.contentView.addSubview(lbAma)
        self.lbAma = lbAma
        
        let vShowAll = UIView()
        vShowAll.translatesAutoresizingMaskIntoConstraints = false
        vShowAll.roundCorners(cornerRadius: 16.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        vShowAll.backgroundColor = .boxMessage
        vShowAll.isUserInteractionEnabled = true
        vShowAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickShowAll(_:))))
        
        let emojiView = EmojiView()
        emojiView.emojiViewDelegate = self
        self.contentView.addSubview(emojiView)
        self.emojiView = emojiView
        
        let lbShowAll = UILabel()
        lbShowAll.translatesAutoresizingMaskIntoConstraints = false
        lbShowAll.text = "notification_board_show_all".localized()
        lbShowAll.textColor = .label
        lbShowAll.font = UIFont.systemFont(ofSize: 12.0)
        vShowAll.addSubview(lbShowAll)
        
        let ivShowAll = UIImageView()
        ivShowAll.translatesAutoresizingMaskIntoConstraints = false
        ivShowAll.image = .rightArrow
        vShowAll.addSubview(ivShowAll)
        
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
        
        let ivTranslateBy = UIImageView()
        ivTranslateBy.translatesAutoresizingMaskIntoConstraints = false
        ivTranslateBy.image = .byGoogle
        ivTranslateBy.isHidden = true
        self.contentView.addSubview(ivTranslateBy)
        self.ivTranslateBy = ivTranslateBy
        
        NSLayoutConstraint.activate([
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            ivProfile.topAnchor.constraint(equalTo: messageDateView.bottomAnchor, constant: 0.0),
            ivProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            lbProfileName.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            lbProfileName.topAnchor.constraint(equalTo: ivProfile.topAnchor),
            
            tvContent.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            tvContent.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
            
            lbDate.leadingAnchor.constraint(equalTo: tvContent.trailingAnchor, constant: 4.0),
            lbDate.bottomAnchor.constraint(equalTo: tvContent.bottomAnchor),
            
            lbAma.leadingAnchor.constraint(equalTo: lbProfileName.trailingAnchor, constant: 6.0),
            lbAma.centerYAnchor.constraint(equalTo: lbProfileName.centerYAnchor),
            
            vShowAll.leadingAnchor.constraint(equalTo: tvContent.leadingAnchor),
            vShowAll.bottomAnchor.constraint(equalTo: tvContent.bottomAnchor),
            vShowAll.trailingAnchor.constraint(equalTo: tvContent.trailingAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: tvContent.leadingAnchor),
        ])
        
        self.profileNameHeightConstraint = lbProfileName.heightAnchor.constraint(equalToConstant: 0.0)
        self.profileTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        self.contentTopConstraint = tvContent.topAnchor.constraint(equalTo: lbProfileName.bottomAnchor, constant: 4.0)
        self.contentBottomConstraint = tvContent.bottomAnchor.constraint(equalTo: emojiView.topAnchor, constant: -4.0)
        self.emojiBottomConstraint = emojiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4.0)
        self.svEmojiViewHeightConstraint = emojiView.heightAnchor.constraint(equalToConstant: 23)
        self.vShowAllHeightContraint = vShowAll.heightAnchor.constraint(equalToConstant: 0)
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        self.profileTopConstraint?.isActive = true
        self.contentTopConstraint?.isActive = true
        self.contentBottomConstraint?.isActive = true
        self.emojiBottomConstraint?.isActive = true
        self.vShowAllHeightContraint?.isActive = true
        self.svEmojiViewHeightConstraint?.isActive = true
        self.profileNameHeightConstraint?.isActive = true
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
                                                         isHeadMessage: self.isHeadMessage, isMyMessage: false, size: tvContent.frame.size, chat: self.chat, isBlockUser: self.isBlockUser)
                }
            }
        }
    }
    
    @objc func clickProfile(_ sender:UITapGestureRecognizer) {
        self.messageCellDelegate?.clickUserProfile(userNickname: self.chat.userNickname, profileImage: self.chat.profileUrl, isNft: self.chat.isNFTProfile, exchange: self.chat.exchange)
    }
    
    @objc func clickShowAll(_ sender:UITapGestureRecognizer) {
        self.messageCellDelegate?.clickAllMessage(message: self.chat.koMessage ?? "", isMine: false, isTranslate: false)
    }
    
    internal func loadData(chat: Chat, isHideDate: Bool, isHeadMessage: Bool, isFirstMessage: Bool, isSameDayPreviousMessage: Bool, isBlockUser: Bool, memberId: String?) {
        self.chat = chat
        self.isHeadMessage = isHeadMessage
        self.isBlockUser = isBlockUser
        if isSameDayPreviousMessage {
            self.messageDateView?.isHidden = true
            self.dateViewHeightConstraint?.constant = 0.0
        } else {
            self.messageDateView?.setUpData(date: chat.insertTime.convertTableKey())
            self.messageDateView?.isHidden = false
            self.dateViewHeightConstraint?.constant = 52.0
        }
        
        if isHeadMessage {
            if let iconUrlString = chat.profileUrl, let imageUrl = NSURL(string: iconUrlString) {
                ImageCache.shared.load(url: imageUrl, completion: { [weak self] image in
                    guard let self = self else { return }
                    guard let image = image else {
                        DispatchQueue.main.async {
                            self.ivProfile?.image = .baseProfile
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.ivProfile?.image = image.centerCrop() ?? .baseProfile
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self.ivProfile?.image = .baseProfile
                }
            }
            self.lbProfileName?.text = chat.userNickname
            
            if chat.label?.uppercased() == "AMA" {
                self.lbAma?.isHidden = false
            } else {
                self.lbAma?.isHidden = true
            }
            
            self.profileNameHeightConstraint?.constant = 18.0
            self.profileTopConstraint?.constant = 4.0
            self.ivProfile?.isHidden = false
            self.lbProfileName?.isHidden = false
            
            self.tvContent?.clipsToBounds = true
            self.tvContent?.layer.cornerRadius = 16.0
            self.tvContent?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        } else {
            self.profileNameHeightConstraint?.constant = 0.0
            self.profileTopConstraint?.constant = 0.0
            self.contentTopConstraint?.constant = 0.0
            
            self.ivProfile?.isHidden = true
            self.lbProfileName?.isHidden = true
            self.lbAma?.isHidden = true
            
            self.tvContent?.clipsToBounds = true
            self.tvContent?.layer.cornerRadius = 16.0
            self.tvContent?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        }
        
        
        if isBlockUser {
            self.tvContent?.text = "message_blocked_user".localized()
            self.vShowAllHeightContraint?.constant = 0
            self.vShowAll?.isHidden = true
        } else {
            if let message = chat.koMessage {
                if message.count > 400 {
                    self.tvContent?.text = message.prefix(397).appending("...\n\n")
                    self.vShowAll?.isHidden = false
                    self.vShowAllHeightContraint?.constant = self.vShowAllHeight
                } else {
                    if let message = chat.koMessage {
                        if message.isCoinMatches() {
                            self.tvContent?.text = message.toCoinMatches()
                        } else if message.isUserMatches() {
                            self.tvContent?.text = message.toUserMatches()
                        } else {
                            self.tvContent?.text = message
                        }
                    }
                    self.vShowAll?.isHidden = true
                    self.vShowAllHeightContraint?.constant = 0
                }
            }
        }
        
        if let emojis = chat.emoji {
            if emojis.count > 0 {
                if emojis.values.contains(where: { emoji in emoji.count > 0}) {
                    self.emojiBottomConstraint?.constant = -4.0
                    self.svEmojiViewHeightConstraint?.constant = 23.0
                    self.emojiView?.isHidden = false
                    self.emojiView?.loadEmoji(emojis: emojis, memberId: memberId ?? "")
                    self.updateConstraintsIfNeeded()
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
}

extension UserMessageCell: FloatMenuActionDelegate {
    func deleteEmojiAction(_ emojiType: EMOJI_TYPE) {
        self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
    }
    
    func emojiAction(_ emojiType: EMOJI_TYPE) {
        self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
    }
    
    func copy() {
        UIPasteboard.general.string = self.chat.koMessage
    }
    
    func cancel() {
        
    }
    
    func block() {
        if let memberId = self.chat.memberId {
            self.messageCellDelegate?.blockMessage(memberId: memberId, isBlock: !self.isBlockUser)
        }
    }
    
    func delete() {
        self.messageCellDelegate?.deleteMessage(chat: self.chat)
    }
    
    func report() {
        
    }
}

extension UserMessageCell: EmojiViewDelegate {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool) {
        if isSelect {
            self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
        } else {
            self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
        }
    }
}
