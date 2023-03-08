//
//  UserAssetMessageCell.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/24.
//

import UIKit
import CoinliveChatSDK

class UserAssetMessageCell: UITableViewCell {
    internal weak var messageCellDelegate : MessageCellDelegate? = nil
    internal weak var floatMenuDelegate: FloatMenuDelegate? = nil
    private var chat: Chat!
    private weak var ivProfile: UIImageView?
    private weak var lbProfileName: UILabel?
    private weak var lbDate: UILabel?
    private weak var tvContent: UITextView?
    private weak var lbAma: PaddingLabel?
    private weak var vAsset: UIView?
    private weak var ivAssetIcon: UIImageView?
    private weak var lbAssetName: UILabel?
    private weak var lbAssetDescription: UILabel?
    private weak var ivExchange: UIImageView?
    private weak var emojiView: EmojiView?
    private weak var messageDateView: MessageDateView?
    
    private var profileImageSize: CGFloat = 32.0
    private var amaLabelHeight: CGFloat = 14.0
    private var assetIconSize: CGFloat = 24.0
    private var assetViewWidth: CGFloat = 245.0
    private var assetViewHeight: CGFloat = 90.0
    private weak var profileTopConstraint: NSLayoutConstraint? = nil
    private weak var contentTopConstraint: NSLayoutConstraint? = nil
    private weak var contentBottomConstraint: NSLayoutConstraint? = nil
    private weak var assetViewHeightConstraint: NSLayoutConstraint? = nil
    private weak var emojiBottomConstraint: NSLayoutConstraint? = nil
    private weak var svEmojiViewHeightConstraint: NSLayoutConstraint? = nil
    private weak var dateLeadingConstraint: NSLayoutConstraint? = nil
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    private var isHeadMessage: Bool = false
    private var isBlockUser: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ivProfile?.image = nil
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
        tvContent.isSelectable = false
        tvContent.translatesAutoresizingMaskIntoConstraints = false
        tvContent.textColor = .label
        tvContent.font = UIFont.systemFont(ofSize: 14)
        tvContent.textContainerInset = .init(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
        tvContent.backgroundColor = .boxMessage
        tvContent.isUserInteractionEnabled = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        longPress.minimumPressDuration = 1
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
        
        let vAsset = UIView()
        vAsset.translatesAutoresizingMaskIntoConstraints = false
        vAsset.layer.borderColor = UIColor.boxAssetBorder.cgColor
        vAsset.layer.borderWidth = 1.0
        vAsset.layer.cornerRadius = 8.0
        
        let longPress2 = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        longPress2.minimumPressDuration = 1
        vAsset.addGestureRecognizer(longPress2)
        
        self.contentView.addSubview(vAsset)
        
        let ivAssetIcon = UIImageView()
        ivAssetIcon.translatesAutoresizingMaskIntoConstraints = false
        ivAssetIcon.layer.cornerRadius = assetIconSize / 2.0
    
        vAsset.addSubview(ivAssetIcon)
        self.ivAssetIcon = ivAssetIcon
        
        let ivExchange = UIImageView()
        ivExchange.translatesAutoresizingMaskIntoConstraints = false
        ivExchange.layer.cornerRadius = assetIconSize / 2.0
        
        vAsset.addSubview(ivExchange)
        self.ivExchange = ivExchange
        
        let lbAssetName = UILabel()
        lbAssetName.translatesAutoresizingMaskIntoConstraints = false
        lbAssetName.textColor = .label
        lbAssetName.font = UIFont.systemFont(ofSize: 16.0)
        lbAssetName.textAlignment = .left
        
        vAsset.addSubview(lbAssetName)
        self.lbAssetName = lbAssetName
        
        let lbAssetDescription = UILabel()
        lbAssetDescription.translatesAutoresizingMaskIntoConstraints = false
        lbAssetDescription.textColor = .label
        lbAssetDescription.font = UIFont.systemFont(ofSize: 16.0)
        lbAssetDescription.textAlignment = .left
        
        vAsset.addSubview(lbAssetDescription)
        self.lbAssetDescription = lbAssetDescription
        
        let emojiView = EmojiView()
        emojiView.emojiViewDelegate = self
        self.contentView.addSubview(emojiView)
        self.emojiView = emojiView
        
        let lbAssetComment = UILabel()
        lbAssetComment.translatesAutoresizingMaskIntoConstraints = false
        lbAssetComment.text = "Coinlive에서 자산인증을 검증한 메시지입니다."
        lbAssetComment.textColor = .assetComment
        lbAssetComment.font = UIFont.systemFont(ofSize: 12.0)
        lbAssetComment.textAlignment = .left
        
        vAsset.addSubview(lbAssetComment)
        self.vAsset = vAsset
        
        NSLayoutConstraint.activate([
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            ivProfile.topAnchor.constraint(equalTo: messageDateView.topAnchor),
            
            ivProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            lbProfileName.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            lbProfileName.topAnchor.constraint(equalTo: ivProfile.topAnchor),
            
            tvContent.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            tvContent.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
            
            vAsset.topAnchor.constraint(equalTo: tvContent.bottomAnchor, constant: 4.0),
            vAsset.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            vAsset.widthAnchor.constraint(equalToConstant: self.assetViewWidth),
            
            lbDate.bottomAnchor.constraint(equalTo: vAsset.bottomAnchor),
            
            lbAma.leadingAnchor.constraint(equalTo: lbProfileName.trailingAnchor, constant: 6.0),
            lbAma.centerYAnchor.constraint(equalTo: lbProfileName.centerYAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: vAsset.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            ivAssetIcon.leadingAnchor.constraint(equalTo: vAsset.leadingAnchor, constant: 12.0),
            ivAssetIcon.topAnchor.constraint(equalTo: vAsset.topAnchor, constant: 6.0),
            ivAssetIcon.widthAnchor.constraint(equalToConstant: self.assetIconSize),
            ivAssetIcon.heightAnchor.constraint(equalToConstant: self.assetIconSize),
            
            lbAssetName.leadingAnchor.constraint(equalTo: ivAssetIcon.trailingAnchor, constant: 4.0),
            lbAssetName.centerYAnchor.constraint(equalTo: ivAssetIcon.centerYAnchor),
            
            lbAssetDescription.topAnchor.constraint(equalTo: ivAssetIcon.bottomAnchor, constant: 8.0),
            lbAssetDescription.leadingAnchor.constraint(equalTo: ivAssetIcon.leadingAnchor),
            lbAssetDescription.trailingAnchor.constraint(equalTo: ivExchange.leadingAnchor),
            lbAssetDescription.widthAnchor.constraint(lessThanOrEqualToConstant: 170),
            
            ivExchange.leadingAnchor.constraint(equalTo: lbAssetDescription.trailingAnchor, constant: 4.0),
            ivExchange.centerYAnchor.constraint(equalTo: lbAssetDescription.centerYAnchor),
            ivExchange.widthAnchor.constraint(equalToConstant: 16.0),
            ivExchange.heightAnchor.constraint(equalToConstant: 16.0),
            
            lbAssetComment.topAnchor.constraint(equalTo: lbAssetDescription.bottomAnchor, constant: 12.0),
            lbAssetComment.leadingAnchor.constraint(equalTo: ivAssetIcon.leadingAnchor),
            lbAssetComment.trailingAnchor.constraint(equalTo: vAsset.trailingAnchor, constant: -4.0)
        ])
        
        self.dateLeadingConstraint = lbDate.leadingAnchor.constraint(equalTo: vAsset.trailingAnchor, constant: 4.0)
        self.profileTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        self.contentTopConstraint = tvContent.topAnchor.constraint(equalTo: lbProfileName.bottomAnchor, constant: 4.0)
        self.contentBottomConstraint = vAsset.bottomAnchor.constraint(equalTo: emojiView.topAnchor, constant: -4.0)
        self.emojiBottomConstraint = emojiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0)
        self.svEmojiViewHeightConstraint = emojiView.heightAnchor.constraint(equalToConstant: 23)
        self.assetViewHeightConstraint = vAsset.heightAnchor.constraint(equalToConstant: self.assetViewHeight)
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        self.profileTopConstraint?.isActive = true
        self.contentTopConstraint?.isActive = true
        self.contentBottomConstraint?.isActive = true
        self.assetViewHeightConstraint?.isActive = true
        self.emojiBottomConstraint?.isActive = true
        self.svEmojiViewHeightConstraint?.isActive = true
        self.dateLeadingConstraint?.isActive = true
        self.dateViewHeightConstraint?.isActive = true
    }
    
    private func loadImageView(url: String?) {
        guard let url = url else {
            return }
        guard let url = NSURL(string: url) else {
            return }
        
        ImageCache.shared.load(url: url, completion: { [weak self] (fetchImage) in
            guard let self = self else { return }
            guard let fetchImage = fetchImage else {
                return
            }
            let resizeImage: UIImage
            if fetchImage.size.width > fetchImage.size.height {
                resizeImage = fetchImage.resizeWithWidth(newWidth: 24)
            } else {
                resizeImage = fetchImage.resizeWithHeight(newHeight: 24)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.ivAssetIcon?.image = resizeImage
            })
        })
    }
    
    @objc func pressContent(_ recogizer: UILongPressGestureRecognizer) {
        guard let tvContent = self.tvContent else { return }
        if recogizer.state == .began {
            self.floatMenuDelegate?.pressKeyboardCheck { [weak self] in
                guard let self = self else { return }
                let point = CGPoint(x: self.frame.origin.x + tvContent.frame.origin.x, y: self.frame.origin.y + tvContent.frame.origin.y)
                if let convertPoint = self.superview?.convert(point, to: nil) {
                    self.floatMenuDelegate?.loadAssetMenu(floatMenuActionDelegate: self,
                                                          position: convertPoint,
                                                          isHeadMessage: self.isHeadMessage,
                                                          isMyMessage: false,
                                                          size: tvContent.frame.size,
                                                          chat: self.chat, isBlockUser: self.isBlockUser)
                }
            }
        }
    }
    
    @objc func clickProfile(_ sender:UITapGestureRecognizer) {
        self.messageCellDelegate?.clickUserProfile(userNickname: self.chat.userNickname, profileImage: self.chat.profileUrl, isNft: self.chat.isNFTProfile, exchange: self.chat.exchange)
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
        
        if self.isBlockUser {
            self.assetViewHeightConstraint?.constant = 0.0
            self.vAsset?.isHidden = true
            self.tvContent?.text = "message_blocked_user".localized()
            self.tvContent?.sizeToFit()
            self.dateLeadingConstraint?.constant = 4.0
        } else {
            self.dateLeadingConstraint?.constant = 4.0
            self.assetViewHeightConstraint?.constant = self.assetViewHeight
            self.vAsset?.isHidden = false
            self.tvContent?.text = chat.koMessage
            self.tvContent?.sizeToFit()
            if let asset = chat.asset {
                self.loadImageView(url: asset.iconUrl)
                self.lbAssetName?.text = asset.symbol
                self.lbAssetDescription?.text = "$\(asset.symbol) \(asset.amount) ($\(String(format: "%.2f", asset.priceDol)))"
                self.lbAssetDescription?.adjustsFontSizeToFitWidth = true
                let exchange = asset.exchange.uppercased()
                DispatchQueue.main.async {
                    if exchange == "UPBIT" {
                        self.ivExchange?.image = .iconUpbit
                    } else if exchange == "BINANCE" {
                        self.ivExchange?.image = .iconBinance
                    } else if exchange == "BITHUMB" {
                        self.ivExchange?.image = .iconBithumb
                    } else if exchange == "COINONE" {
                        self.ivExchange?.image = .iconCoinone
                    } else if exchange == "METAKMASK" {
                        self.ivExchange?.image = .iconMetamask
                    }
                }
            }
        }
        
        if isHideDate {
            self.emojiBottomConstraint?.constant = -4.0
        } else {
            self.emojiBottomConstraint?.constant = -8.0
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
            self.emojiBottomConstraint?.constant = 4.0
            
            if isFirstMessage {
                self.emojiBottomConstraint?.constant = 0.0
            } else {
                self.emojiBottomConstraint?.constant = -8.0
            }
            
            self.profileTopConstraint?.constant = 4.0
            self.ivProfile?.isHidden = false
            self.lbProfileName?.isHidden = false
            
            self.tvContent?.clipsToBounds = true
            self.tvContent?.layer.cornerRadius = 16.0
            self.tvContent?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        } else {
            self.contentTopConstraint?.constant = 4.0
            
            self.ivProfile?.isHidden = true
            self.lbProfileName?.isHidden = true
            self.lbAma?.isHidden = true
            
            self.tvContent?.clipsToBounds = true
            self.tvContent?.layer.cornerRadius = 16.0
            self.tvContent?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        }
        
        if let emojis = chat.emoji {
            if emojis.count > 0 {
                if emojis.values.contains(where: { emoji in emoji.count > 0}) {
                    self.svEmojiViewHeightConstraint?.constant = 23.0
                    self.contentBottomConstraint?.constant = -4.0
                    self.emojiBottomConstraint?.constant = -4.0
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
                self.contentBottomConstraint?.constant = 0.0
            }
        } else {
            self.svEmojiViewHeightConstraint?.constant = 0.0
            self.emojiView?.isHidden = true
            self.emojiView?.hideEmoji()
            self.contentBottomConstraint?.constant = 0.0
        }
        
        self.lbDate?.isHidden = isHideDate
        if !isHideDate {
            self.lbDate?.text = chat.insertTime.convertDateFormat(form: "a hh:mm", locale: .current)
        }
    }
}

extension UserAssetMessageCell: FloatMenuActionDelegate {
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

extension UserAssetMessageCell: EmojiViewDelegate {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool) {
        if isSelect {
            self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
        } else {
            self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
        }
    }
}
