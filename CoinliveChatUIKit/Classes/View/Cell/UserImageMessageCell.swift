//
//  UserImageMessageCell.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/22.
//

import UIKit
import CoinliveChatSDK

class UserImageMessageCell: UITableViewCell {
    internal weak var messageCellDelegate: MessageCellDelegate? = nil
    internal weak var floatMenuDelegate: FloatMenuDelegate? = nil
    private var chat: Chat!
    private weak var ivProfile: UIImageView?
    private weak var lbProfileName: UILabel?
    private weak var ivSingle: UIImageView?
    private weak var lbDate: UILabel?
    private weak var lbAma: PaddingLabel?
    private weak var emojiView: EmojiView?
    private weak var messageDateView: MessageDateView?
    
    private weak var targetImage: UIImage? = nil
    private var amaLabelHeight: CGFloat = 14.0
    
    private var profileImageSize: CGFloat = 32.0
    private weak var profileTopConstraint: NSLayoutConstraint? = nil
    private weak var ivWidthSizeConstraint: NSLayoutConstraint? = nil
    private weak var ivHeightSizeConstraint: NSLayoutConstraint? = nil
    private weak var contentBottomConstraint: NSLayoutConstraint? = nil
    private weak var svEmojiViewHeightConstraint: NSLayoutConstraint? = nil
    private weak var emojiBottomConstraint: NSLayoutConstraint? = nil
    private weak var profileNameHeightConstraint: NSLayoutConstraint? = nil
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    
    private var isLoadedImage: Bool = false
    private var isBlockUser: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeUi()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ivSingle?.image = nil
        self.targetImage = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func initializeUi() {
        self.backgroundColor = .background
        selectionStyle = .none
        
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
        
        let ivSingle = UIImageView()
        ivSingle.translatesAutoresizingMaskIntoConstraints = false
        //        ivSingle.isHidden = true
        ivSingle.clipsToBounds = true
        ivSingle.layer.cornerRadius = 6.0
        ivSingle.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.contentView.addSubview(ivSingle)
        let contentPress = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        contentPress.minimumPressDuration = 1
        ivSingle.isUserInteractionEnabled = true
        ivSingle.addGestureRecognizer(contentPress)
        
        self.ivSingle = ivSingle
        
        let lbDate = UILabel()
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.font = UIFont.systemFont(ofSize: 12)
        lbDate.textColor = .labelMessageDate
        lbDate.textAlignment = .left
        self.contentView.addSubview(lbDate)
        self.lbDate = lbDate
        
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
        
        let emojiView = EmojiView()
        emojiView.emojiViewDelegate = self
        self.contentView.addSubview(emojiView)
        self.emojiView = emojiView
        
        NSLayoutConstraint.activate([
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            ivProfile.topAnchor.constraint(equalTo: messageDateView.bottomAnchor, constant: 0.0),
            ivProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            lbProfileName.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            lbProfileName.topAnchor.constraint(equalTo: ivProfile.topAnchor),
            
            ivSingle.topAnchor.constraint(equalTo: lbProfileName.bottomAnchor, constant: 4.0),
            ivSingle.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            
            lbDate.leadingAnchor.constraint(equalTo: ivSingle.trailingAnchor, constant: 4.0),
            lbDate.bottomAnchor.constraint(equalTo: ivSingle.bottomAnchor),
            
            lbAma.leadingAnchor.constraint(equalTo: lbProfileName.trailingAnchor, constant: 6.0),
            lbAma.centerYAnchor.constraint(equalTo: lbProfileName.centerYAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: ivSingle.leadingAnchor),
        ])
        
        self.profileTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        self.profileNameHeightConstraint = lbProfileName.heightAnchor.constraint(equalToConstant: 0)
        self.ivWidthSizeConstraint = ivSingle.widthAnchor.constraint(equalToConstant: 241)
        self.ivHeightSizeConstraint = ivSingle.heightAnchor.constraint(equalToConstant: 241)
        self.contentBottomConstraint = ivSingle.bottomAnchor.constraint(equalTo: emojiView.topAnchor, constant: -4.0)
        self.emojiBottomConstraint = emojiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4.0)
        self.svEmojiViewHeightConstraint = emojiView.heightAnchor.constraint(equalToConstant: 23)
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        
        self.ivWidthSizeConstraint?.isActive = true
        self.ivHeightSizeConstraint?.isActive = true
        self.profileTopConstraint?.isActive = true
        self.contentBottomConstraint?.isActive = true
        self.svEmojiViewHeightConstraint?.isActive = true
        self.emojiBottomConstraint?.isActive = true
        self.profileNameHeightConstraint?.isActive = true
        self.dateViewHeightConstraint?.isActive = true
    }
    
    internal func resizeImageViewHeight(image: UIImage, height: CGFloat) {
        self.ivHeightSizeConstraint?.constant = height / 1440 * 241
        self.ivWidthSizeConstraint?.constant = 241
        self.targetImage = image
        self.ivSingle?.image = image
    }
    
    internal func resizeImageViewWidth(image: UIImage, width: CGFloat) {
        self.ivWidthSizeConstraint?.constant = width / 1440 * 241
        self.ivHeightSizeConstraint?.constant = 241
        self.targetImage = image
        self.ivSingle?.image = image
    }
    
    @objc func pressContent(_ recogizer: UILongPressGestureRecognizer) {
        guard let ivSingle = self.ivSingle else { return }
        if recogizer.state == .began {
            self.floatMenuDelegate?.pressKeyboardCheck { [weak self] in
                guard let self = self else { return }
                let point = CGPoint(x: self.frame.origin.x + ivSingle.frame.origin.x, y: self.frame.origin.y + ivSingle.frame.origin.y)
                if let convertPoint = self.superview?.convert(point, to: nil), let image = self.targetImage {
                    self.floatMenuDelegate?.loadImageMenu(floatMenuActionDelegate: self,
                                                          position: convertPoint,
                                                          isMyMessage: false,
                                                          image: image,
                                                          chat: self.chat,
                                                          isBlockUser: self.isBlockUser)
                }
            }
        }
    }
    
    @objc func clickProfile(_ sender:UITapGestureRecognizer) {
        self.messageCellDelegate?.clickUserProfile(userNickname: self.chat.userNickname, profileImage: self.chat.profileUrl, isNft: self.chat.isNFTProfile, exchange: self.chat.exchange)
    }
    
    internal func loadFailed() {
        let image: UIImage = .imgLoadFailed
        self.ivSingle?.image = image
        self.ivWidthSizeConstraint?.constant = image.size.width
        self.ivHeightSizeConstraint?.constant = image.size.height
        self.ivSingle?.contentMode = .scaleAspectFit
        self.ivSingle?.layoutIfNeeded()
    }
    
    internal func loadData(chat: Chat, isHideDate: Bool, isHeadMessage: Bool, isFirstMessage: Bool, isSameDayPreviousMessage: Bool, isBlockUser: Bool, memberId: String?) {
        self.chat = chat
        self.isBlockUser = isBlockUser
        if isBlockUser {
            self.targetImage = .blockedUserImageMessage
            self.ivSingle?.image = .blockedUserImageMessage
            self.ivWidthSizeConstraint?.constant = 120.0
            self.ivHeightSizeConstraint?.constant = 120.0
            self.ivSingle?.layoutIfNeeded()
        }
        
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
            if chat.label?.uppercased() == "AMA" {
                self.lbAma?.isHidden = false
            } else {
                self.lbAma?.isHidden = true
            }
            self.profileTopConstraint?.constant = 4.0
            self.lbProfileName?.text = chat.userNickname
            self.profileNameHeightConstraint?.constant = 18.0
            
            self.ivProfile?.isHidden = false
            self.lbProfileName?.isHidden = false
        } else {
            self.profileNameHeightConstraint?.constant = 0.0
            self.profileTopConstraint?.constant = 0.0
            self.ivProfile?.isHidden = true
            self.lbProfileName?.isHidden = true
            self.lbAma?.isHidden = true
        }
        
        if let emojis = chat.emoji {
            if emojis.count > 0 {
                if emojis.values.contains(where: { emoji in emoji.count > 0}) {
                    self.svEmojiViewHeightConstraint?.constant = 23.0
                    self.contentBottomConstraint?.constant = -4.0
                    self.emojiBottomConstraint?.constant = -4.0
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
                self.contentBottomConstraint?.constant = 0.0
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

extension UserImageMessageCell: FloatMenuActionDelegate {
    func deleteEmojiAction(_ emojiType: EMOJI_TYPE) {
        self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
    }
    
    func emojiAction(_ emojiType: EMOJI_TYPE) {
        self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
    }
    
    func copy() {
    }
    
    func cancel() {
        
    }
    
    func block() {
        if let memberId = self.chat.memberId {
            self.messageCellDelegate?.blockMessage(memberId: memberId, isBlock: !self.isBlockUser)
        }
    }
    
    func delete() {
        
    }
    
    func report() {
        
    }
}

extension UserImageMessageCell: EmojiViewDelegate {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool) {
        if isSelect {
            self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
        } else {
            self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
        }
    }
}
