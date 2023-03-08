//
//  UserMultiImageMessageCell.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/14.
//

import UIKit
import CoinliveChatSDK

class UserMultiImageMessageCell: UITableViewCell {
    internal weak var messageCellDelegate: MessageCellDelegate? = nil
    internal weak var floatMenuDelegate: FloatMenuDelegate? = nil
    private var chat: Chat!
    private weak var ivProfile: UIImageView?
    private weak var lbProfileName: UILabel?
    private weak var cvImages: UICollectionView?
    private weak var lbDate: UILabel?
    private weak var lbAma: PaddingLabel?
    private weak var emojiView: EmojiView?
    private weak var messageDateView: MessageDateView?
    
    private var targetImage: Array<UIImage> = []
    private var amaLabelHeight: CGFloat = 14.0
    
    private let normalSize: CGFloat = 120.0
    private let miniSize: CGFloat = 80.0
    
    private var profileImageSize: CGFloat = 32.0
    private var profileTopConstraint: NSLayoutConstraint? = nil
    private var ivWidthSizeConstraint: NSLayoutConstraint? = nil
    private var ivHeightSizeConstraint: NSLayoutConstraint? = nil
    private var contentBottomConstraint: NSLayoutConstraint? = nil
    private var svEmojiViewHeightConstraint: NSLayoutConstraint? = nil
    private var emojiBottomConstraint: NSLayoutConstraint? = nil
    private var profileNameHeightConstraint: NSLayoutConstraint? = nil
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    
    private var isLoadedImage: Bool = false
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
        
        let gridFlowLayout = UICollectionViewFlowLayout()
        gridFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gridFlowLayout.itemSize = CGSize(width: 20, height: 20)
        gridFlowLayout.minimumLineSpacing = 1
        gridFlowLayout.minimumInteritemSpacing = 1
        
        let cvImages = UICollectionView(frame: .zero, collectionViewLayout: gridFlowLayout)
        cvImages.isScrollEnabled = false
        cvImages.contentInset = .zero
        cvImages.clipsToBounds = true
        cvImages.backgroundColor = .white.withAlphaComponent(0)
        cvImages.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        cvImages.translatesAutoresizingMaskIntoConstraints = false
        cvImages.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        longPress.minimumPressDuration = 1
        cvImages.addGestureRecognizer(longPress)
        self.contentView.addSubview(cvImages)
        cvImages.delegate = self
        cvImages.dataSource = self
        
        self.cvImages = cvImages
        
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
            ivProfile.topAnchor.constraint(equalTo: messageDateView.topAnchor),
            
            ivProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            lbProfileName.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),
            lbProfileName.topAnchor.constraint(equalTo: ivProfile.topAnchor),
            
            cvImages.topAnchor.constraint(equalTo: lbProfileName.bottomAnchor, constant: 4.0),
            cvImages.leadingAnchor.constraint(equalTo: ivProfile.trailingAnchor, constant: 8.0),

            lbDate.leadingAnchor.constraint(equalTo: cvImages.trailingAnchor, constant: 4.0),
            lbDate.bottomAnchor.constraint(equalTo: cvImages.bottomAnchor),
            
            lbAma.leadingAnchor.constraint(equalTo: lbProfileName.trailingAnchor, constant: 6.0),
            lbAma.centerYAnchor.constraint(equalTo: lbProfileName.centerYAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: cvImages.leadingAnchor),
        ])
        
        self.profileTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        self.profileNameHeightConstraint = lbProfileName.heightAnchor.constraint(equalToConstant: 0)
        self.ivWidthSizeConstraint = cvImages.widthAnchor.constraint(equalToConstant: (self.normalSize * 2) + 2)
        self.ivHeightSizeConstraint = cvImages.heightAnchor.constraint(equalToConstant: 0)
        self.contentBottomConstraint = cvImages.bottomAnchor.constraint(equalTo: emojiView.topAnchor, constant: -4.0)
        self.emojiBottomConstraint = emojiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0.0)
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
    
    @objc func pressContent(_ recogizer: UILongPressGestureRecognizer) {
        guard let cvImages = self.cvImages else { return }
        if recogizer.state == .began {
            self.floatMenuDelegate?.pressKeyboardCheck { [weak self] in
                guard let self = self else { return }
                let point = CGPoint(x: self.frame.origin.x + cvImages.frame.origin.x, y: self.frame.origin.y + cvImages.frame.origin.y)
                if let convertPoint = self.superview?.convert(point, to: nil) {
                    self.floatMenuDelegate?.loadMultiImageMenu(floatMenuActionDelegate: self,
                                                               position: convertPoint,
                                                               isMyMessage: false,
                                                               images: self.targetImage,
                                                               size: cvImages.frame.size,
                                                               chat: self.chat,
                                                               isBlockUser: self.isBlockUser)
                }
            }
        }
    }
    
    @objc func clickProfile(_ sender:UITapGestureRecognizer) {
        self.messageCellDelegate?.clickUserProfile(userNickname: self.chat.userNickname, profileImage: self.chat.profileUrl, isNft: self.chat.isNFTProfile, exchange: self.chat.exchange)
    }
    
    internal func loadData(chat: Chat, isHideDate: Bool, isHeadMessage: Bool, isFirstMessage: Bool, isSameDayPreviousMessage: Bool, isBlockUser: Bool, memberId: String?) {
        self.chat = chat
        self.isBlockUser = isBlockUser
        if isSameDayPreviousMessage {
            self.messageDateView?.isHidden = true
            self.dateViewHeightConstraint?.constant = 0.0
        } else {
            self.messageDateView?.setUpData(date: chat.insertTime.convertTableKey())
            self.messageDateView?.isHidden = false
            self.dateViewHeightConstraint?.constant = 52.0
        }
        
        if let images = chat.images {
            if images.count == 2 {
                self.ivHeightSizeConstraint?.constant = self.normalSize
            } else if images.count == 3 {
                self.ivHeightSizeConstraint?.constant = self.miniSize
            } else if images.count == 4 {
                self.ivHeightSizeConstraint?.constant = (self.normalSize) * 2
            } else if images.count == 5 {
                self.ivHeightSizeConstraint?.constant = self.normalSize + self.miniSize
            } else if images.count == 6 {
                self.ivHeightSizeConstraint?.constant = (self.miniSize) * 2
            } else if images.count == 7 {
                self.ivHeightSizeConstraint?.constant = ((self.normalSize) * 2) + self.miniSize
            } else if images.count == 8 {
                self.ivHeightSizeConstraint?.constant = self.normalSize + ((self.miniSize) * 2)
            } else if images.count == 9 {
                self.ivHeightSizeConstraint?.constant = (self.miniSize) * 3
            } else if images.count == 10 {
                self.ivHeightSizeConstraint?.constant = ((self.normalSize) * 2) + ((self.miniSize) * 2)
            }
        }
        self.cvImages?.reloadData()
        
        if isHeadMessage {
            if let iconUrlString = chat.profileUrl, let imageUrl = NSURL(string: iconUrlString) {
                ImageCache.shared.load(url: imageUrl, completion: { image in
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
            self.lbProfileName?.text = chat.userNickname
            self.profileNameHeightConstraint?.constant = 18.0
            self.profileTopConstraint?.constant = 4.0
            
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

extension UserMultiImageMessageCell: FloatMenuActionDelegate {
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

extension UserMultiImageMessageCell: EmojiViewDelegate {
    func clickEmoji(emojiType: EMOJI_TYPE, isSelect: Bool) {
        if isSelect {
            self.messageCellDelegate?.deleteEmoji(chat: self.chat, emojiType: emojiType)
        } else {
            self.messageCellDelegate?.addEmoji(chat: self.chat, emojiType: emojiType)
        }
    }
}

extension UserMultiImageMessageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let images = chat.images {
            if images.count == 2 {
                return CGSize(width: self.normalSize, height: self.normalSize)
            } else if images.count == 3 {
                return CGSize(width: self.miniSize, height: self.miniSize)
            } else if images.count == 4 {
                return CGSize(width: self.normalSize, height: self.normalSize)
            } else if images.count == 5 {
                if indexPath.section == 0 {
                    return CGSize(width: self.miniSize, height: self.miniSize)
                } else {
                    return CGSize(width: self.normalSize, height: self.normalSize)
                }
            } else if images.count == 6 {
                return CGSize(width: self.miniSize, height: self.miniSize)
            } else if images.count == 7 {
                if indexPath.section == 0 {
                    return CGSize(width: self.miniSize, height: self.miniSize)
                } else {
                    return CGSize(width: self.normalSize, height: self.normalSize)
                }
            } else if images.count == 8 {
                if indexPath.section == 0 || indexPath.section == 1 {
                    return CGSize(width: self.miniSize, height: self.miniSize)
                } else {
                    return CGSize(width: self.normalSize, height: self.normalSize)
                }
            } else if images.count == 9 {
                return CGSize(width: self.miniSize, height: self.miniSize)
            } else if images.count == 10 {
                if indexPath.section == 0 || indexPath.section == 1 {
                    return CGSize(width: self.miniSize, height: self.miniSize)
                } else {
                    return CGSize(width: self.normalSize, height: self.normalSize)
                }
            }
        }
        return CGSize(width: 0, height: 0)
    }
}

extension UserMultiImageMessageCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if let images = self.chat.images {
            if self.isBlockUser {
                cell.prepare(image: .blockedUserImageMessage)
            } else {
                var imageIndex: Int = indexPath.row
                var section = indexPath.section
                while section != 0 {
                    section -= 1
                    imageIndex += collectionView.numberOfItems(inSection: section)
                }
                
                let urlString = images[imageIndex]
                if let url = NSURL(string: urlString) {
                    ImageCache.shared.load(url: url, completion: { [weak self] (fetchImage) in
                        guard let self = self else { return }
                        guard let fetchImage = fetchImage else {
                            cell.prepare(image: .imgLoadFailed)
                            return
                        }
                        
                        guard let croppedImage = fetchImage.centerCrop() else {
                            cell.prepare(image: .imgLoadFailed)
                            return
                        }
                        
                        let resizeImage = croppedImage.resizeWithWidth(newWidth: 120)
                        // TODO block ??
                        self.targetImage.append(resizeImage)
                        DispatchQueue.main.async {
                            cell.prepare(image: resizeImage)
                        }
                    })
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = chat.images {
            if images.count == 2 {
                return 2
            } else if images.count == 3 {
                return 3
            } else if images.count == 4 {
                return 2
            } else if images.count == 5 {
                if section == 0 {
                    return 3
                } else {
                    return 2
                }
            } else if images.count == 6 {
                return 3
            } else if images.count == 7 {
                if section == 0 {
                    return 3
                } else {
                    return 2
                }
            } else if images.count == 8 {
                if section == 2 {
                    return 2
                } else {
                    return 3
                }
            } else if images.count == 9 {
                return 3
            } else if images.count == 10 {
                if section == 0 || section == 1 {
                    return 3
                } else {
                    return 2
                }
            }
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let images = chat.images {
            if images.count == 2 {
                return 1
            } else if images.count == 3 {
                return 1
            } else if images.count == 4 {
                return 2
            } else if images.count == 5 {
                return 2
            } else if images.count == 6 {
                return 2
            } else if images.count == 7 {
                return 3
            } else if images.count == 8 {
                return 3
            } else if images.count == 9 {
                return 3
            } else if images.count == 10 {
                return 4
            }
        }
        return 0
    }
}
