//
//  FloatChatMenuView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/01.
//

import UIKit
import CoinliveChatSDK

class FloatChatMenuView: UIView {
    weak var floatMenuActionDelegate: FloatMenuActionDelegate?
    weak var menuViewActionDelegate: MenuViewActionDelegate?
    private let emojiViewSize: CGSize = CGSize(width: 252, height: 40)
    private let menuViewSize: CGSize = CGSize(width: 252, height: 200)
    private let menuViewSize4: CGSize = CGSize(width: 252, height: 160)
    private let menuViewSize3: CGSize = CGSize(width: 252, height: 120)
    private let menuViewSize2: CGSize = CGSize(width: 252, height: 80)
    private let menuLineHeight: CGFloat = 40.0
    private let marginBetweenView: CGFloat = 6.0
    private let maximumHeight: CGFloat = 40.0 + 200.0 + 6.0
    private let emojiBtnSize: CGFloat = 30.0
    private let menuIconSize: CGFloat = 18.0
    private var assetViewWidth: CGFloat = 245.0
    private var assetViewHeight: CGFloat = 90.0
    private var assetIconSize: CGFloat = 24.0
    private var vShowAllHeight: CGFloat = 36.0
    private var showAllArrowImageSize: CGFloat = 16.0
    private let normalSize: CGFloat = 120.0
    private let miniSize: CGFloat = 80.0
    
    private weak var ivImage: UIImageView?
    private weak var cvImages: UICollectionView?
    private weak var tvMessage: UITextView?
    private weak var vAsset: UIView?
    private weak var vShowAll: UIView?
    private var chat: Chat? = nil
    private var isBlockUser: Bool = false
    private var memberId: String? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeUi()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeUi()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.initializeUi()
    }
    
    private func initializeUi() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeChatMenu)))
        
        let tvMessage = UITextView()
        self.addSubview(tvMessage)
        self.tvMessage = tvMessage
        
        let ivImage = UIImageView()
        ivImage.clipsToBounds = true
        ivImage.layer.cornerRadius = 6.0
        self.addSubview(ivImage)
        self.ivImage = ivImage
        
        let vAsset = UIView()
        self.addSubview(vAsset)
        self.vAsset = vAsset
        
        let vShowAll = UIView()
        self.addSubview(vShowAll)
        self.vShowAll = vShowAll
        
        let gridFlowLayout = UICollectionViewFlowLayout()
        gridFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gridFlowLayout.itemSize = CGSize(width: 20, height: 20)
        gridFlowLayout.minimumLineSpacing = 1
        gridFlowLayout.minimumInteritemSpacing = 1
        
        let cvImages = UICollectionView(frame: .zero, collectionViewLayout: gridFlowLayout)
        cvImages.isScrollEnabled = false
        cvImages.contentInset = .zero
        cvImages.clipsToBounds = true
        cvImages.backgroundColor = .white.withAlphaComponent(0.0)
        cvImages.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        self.addSubview(cvImages)
        self.cvImages = cvImages
        
        cvImages.delegate = self
        cvImages.dataSource = self
    }
    
    internal func loadTextMenu(position: CGPoint,
                               isHeadMessage: Bool,
                               isMyMessage: Bool,
                               size: CGSize,
                               chat: Chat,
                               baseViewHeight: CGFloat,
                               isBlockUser: Bool,
                               memberId: String?) {
        self.chat = chat
        self.isBlockUser = isBlockUser
        self.memberId = memberId
        self.ivImage?.removeFromSuperview()
        self.cvImages?.removeFromSuperview()
        
        self.tvMessage?.frame = CGRect(origin: position, size: size)
        self.tvMessage?.clipsToBounds = true
        self.tvMessage?.layer.cornerRadius = 16.0
        if isHeadMessage {
            if isMyMessage {
                self.tvMessage?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner,. layerMinXMaxYCorner]
            } else {
                self.tvMessage?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
            }
        } else {
            self.tvMessage?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        }
        
        self.tvMessage?.isEditable = false
        self.tvMessage?.isScrollEnabled = false
        self.tvMessage?.isSelectable = false
        self.tvMessage?.textColor = isMyMessage ? .white : .label
        self.tvMessage?.font = UIFont.systemFont(ofSize: 14)
        self.tvMessage?.textContainerInset = .init(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        self.tvMessage?.backgroundColor = isMyMessage ? .primary : .boxMessage
        
        self.vShowAll?.frame = CGRect(origin: CGPoint(x: position.x, y: (position.y + size.height - self.vShowAllHeight) ), size: CGSize(width: size.width, height: self.vShowAllHeight))
        self.vShowAll?.roundCorners(cornerRadius: 16.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        vShowAll?.backgroundColor = isMyMessage ? .primary : .boxMessage
        
        let lbShowAll = UILabel()
        lbShowAll.translatesAutoresizingMaskIntoConstraints = false
        lbShowAll.text = "notification_board_show_all".localized()
        lbShowAll.textColor = isMyMessage ? .white : .label
        lbShowAll.font = UIFont.systemFont(ofSize: 12.0)
        vShowAll?.addSubview(lbShowAll)
        
        let ivShowAll = UIImageView()
        ivShowAll.translatesAutoresizingMaskIntoConstraints = false
        ivShowAll.image = isMyMessage ? .rightArrowWhite : .rightArrow
        vShowAll?.addSubview(ivShowAll)
        
        if let vShowAll = self.vShowAll {
            NSLayoutConstraint.activate([
                lbShowAll.leadingAnchor.constraint(equalTo: vShowAll.leadingAnchor, constant: 12.0),
                lbShowAll.centerYAnchor.constraint(equalTo: vShowAll.centerYAnchor),
                
                ivShowAll.trailingAnchor.constraint(equalTo: vShowAll.trailingAnchor, constant: -12.0),
                ivShowAll.centerYAnchor.constraint(equalTo: vShowAll.centerYAnchor),
                ivShowAll.widthAnchor.constraint(equalToConstant: self.showAllArrowImageSize),
                ivShowAll.heightAnchor.constraint(equalToConstant: self.showAllArrowImageSize)
            ])
        }
        
        
        if isBlockUser {
            self.tvMessage?.text = "message_blocked_user".localized()
            self.vShowAll?.isHidden = true
        } else {
            if let message = chat.koMessage {
                if message.count > 400 {
                    self.vShowAll?.isHidden = false
                    self.tvMessage?.text = message.prefix(397).appending("...\n\n")
                } else {
                    self.vShowAll?.isHidden = true
                    if message.isCoinMatches() {
                        self.tvMessage?.text = message.toCoinMatches()
                    } else if message.isUserMatches() {
                        self.tvMessage?.text = message.toUserMatches()
                    } else {
                        self.tvMessage?.text = message
                    }
                }
            }
        }
        self.vShowAll?.layoutIfNeeded()
        
        self.tvMessage?.setNeedsLayout()
        self.tvMessage?.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        lbShowAll.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        ivShowAll.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        UIView.animate(withDuration: 0.3, animations: {
            self.tvMessage?.transform = .identity
            lbShowAll.transform = .identity
            ivShowAll.transform = .identity
            self.tvMessage?.layoutIfNeeded()
            lbShowAll.layoutIfNeeded()
            ivShowAll.layoutIfNeeded()
        })
        
        if memberId == nil {
            let contentSize = size.height + (marginBetweenView * 2) + self.menuViewSize2.height + 30.0
            self.createAnonymousMenuViews(position: position, height: size.height, isReversed: (position.y + contentSize) > baseViewHeight)
        } else {
            if isMyMessage {
                let contentSize = size.height + (marginBetweenView * 2) + self.menuViewSize3.height + 30.0
                let leftPosition = CGPoint(x: (position.x - menuViewSize.width) + size.width, y: position.y)
                self.createNoBlockNoReportMenuViews(position: leftPosition, height: size.height, isReversed: (position.y + contentSize) > baseViewHeight)
            } else {
                let contentSize = size.height + (marginBetweenView * 2) + self.emojiViewSize.height + self.menuViewSize4.height + 30.0
                self.createNoDeleteMenuViews(position: position, height: size.height, isReversed: (position.y + contentSize) > baseViewHeight)
            }
        }
    }
    
    internal func loadImageMenu(position: CGPoint,
                                image: UIImage,
                                isMyMessage: Bool,
                                baseViewHeight: CGFloat,
                                chat: Chat,
                                isBlockUser: Bool,
                                memberId: String?) {
        self.chat = chat
        self.isBlockUser = isBlockUser
        self.memberId = memberId
        self.vAsset?.removeFromSuperview()
        self.tvMessage?.removeFromSuperview()
        self.cvImages?.removeFromSuperview()
        var height: CGFloat = 241
        var width: CGFloat = 241
        let blockImage: UIImage = .blockedUserImageMessage
        if isBlockUser {
            height = blockImage.size.height
            self.ivImage?.frame = CGRect(origin: position, size: blockImage.size)
            self.ivImage?.image = .blockedUserImageMessage
        } else {
            if image.size.width > image.size.height {
                height = image.size.height / 1440 * 241
            } else {
                width = image.size.width / 1440 * 241
            }
            self.ivImage?.frame = CGRect(origin: position, size: CGSize(width: width, height: height))
            self.ivImage?.image = image
        }
        self.ivImage?.setNeedsLayout()
        
        self.ivImage?.transform = CGAffineTransform.init(scaleX: 1.01, y: 1.01)
        UIView.animate(withDuration: 0.3, animations: {
            self.ivImage?.transform = .identity
            self.ivImage?.layoutIfNeeded()
        })
        
        if isMyMessage {
            let contentSize = height + (marginBetweenView * 2) + self.emojiViewSize.height + self.menuViewSize2.height + 30.0
            let leftPosition = CGPoint(x: (position.x - menuViewSize.width) + width, y: position.y)
            self.createNoBlockNoReportNoCopyMenuViews(position: leftPosition, height: height, isReversed: (position.y + contentSize) > baseViewHeight)
        } else {
            let contentSize = height + (marginBetweenView * 2) + self.emojiViewSize.height + self.menuViewSize3.height + 30.0
            self.createNoCopyNoDeleteMenuViews(position: position, height: height, isReversed: (position.y + contentSize) > baseViewHeight)
        }
    }
    
    internal func loadMultiImageMenu(position: CGPoint,
                                     images: Array<UIImage>,
                                     isMyMessage: Bool,
                                     baseViewHeight: CGFloat,
                                     chat: Chat,
                                     size: CGSize,
                                     isBlockUser: Bool,
                                     memberId: String?) {
        self.vAsset?.removeFromSuperview()
        self.tvMessage?.removeFromSuperview()
        self.cvImages?.frame = CGRect(origin: position, size: size)
        self.chat = chat
        self.isBlockUser = isBlockUser
        self.memberId = memberId
        
        self.cvImages?.transform = CGAffineTransform.init(scaleX: 1.01, y: 1.01)
        UIView.animate(withDuration: 0.3, animations: {
            self.cvImages?.transform = .identity
            self.cvImages?.layoutIfNeeded()
        })
        
        if isMyMessage {
            let contentSize = size.height + (marginBetweenView * 2) + self.emojiViewSize.height + self.menuViewSize2.height + 30.0
            let leftPosition = CGPoint(x: (position.x - menuViewSize.width) + size.width, y: position.y)
            self.createNoBlockNoReportNoCopyMenuViews(position: leftPosition, height: size.height, isReversed: (position.y + contentSize) > baseViewHeight)
        } else {
            let contentSize = size.height + (marginBetweenView * 2) + self.emojiViewSize.height + self.menuViewSize3.height + 30.0
            self.createNoCopyNoDeleteMenuViews(position: position, height: size.height, isReversed: (position.y + contentSize) > baseViewHeight)
        }
    }
    
    internal func loadAssetMenu(position: CGPoint,
                                isHeadMessage: Bool,
                                isMyMessage: Bool,
                                size: CGSize,
                                chat: Chat,
                                baseViewHeight: CGFloat,
                                isBlockUser: Bool,
                                memberId: String?) {
        self.chat = chat
        self.isBlockUser = isBlockUser
        self.memberId = memberId
        self.ivImage?.removeFromSuperview()
        self.cvImages?.removeFromSuperview()
        self.tvMessage?.frame = CGRect(origin: position, size: size)
        self.tvMessage?.clipsToBounds = true
        self.tvMessage?.layer.cornerRadius = 16.0
        if isHeadMessage {
            self.tvMessage?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        } else {
            self.tvMessage?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner]
        }
        
        self.tvMessage?.isEditable = false
        self.tvMessage?.isScrollEnabled = false
        self.tvMessage?.isSelectable = false
        self.tvMessage?.textColor = .label
        self.tvMessage?.font = UIFont.systemFont(ofSize: 14)
        self.tvMessage?.textContainerInset = .init(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)
        self.tvMessage?.backgroundColor = .boxMessage
        
        self.tvMessage?.setNeedsLayout()
        
        let assetPosition = CGPoint(x: position.x, y: (position.y + 4.0 + size.height))
        
        self.vAsset?.frame = CGRect(origin: assetPosition, size: CGSize(width: self.assetViewWidth, height: self.assetViewHeight))
        self.vAsset?.layer.borderColor = UIColor.boxAssetBorder.cgColor
        self.vAsset?.backgroundColor = .background
        self.vAsset?.layer.borderWidth = 1.0
        self.vAsset?.layer.cornerRadius = 8.0
        
        let ivAssetIcon = UIImageView()
        ivAssetIcon.translatesAutoresizingMaskIntoConstraints = false
        ivAssetIcon.layer.cornerRadius = assetIconSize / 2.0
        
        self.vAsset?.addSubview(ivAssetIcon)
        
        let ivExchange = UIImageView()
        ivExchange.translatesAutoresizingMaskIntoConstraints = false
        ivExchange.layer.cornerRadius = assetIconSize / 2.0
        
        self.vAsset?.addSubview(ivExchange)
        
        let lbAssetName = UILabel()
        lbAssetName.translatesAutoresizingMaskIntoConstraints = false
        lbAssetName.textColor = .label
        lbAssetName.font = UIFont.systemFont(ofSize: 16.0)
        lbAssetName.textAlignment = .left
        
        self.vAsset?.addSubview(lbAssetName)
        
        let lbAssetDescription = UILabel()
        lbAssetDescription.translatesAutoresizingMaskIntoConstraints = false
        lbAssetDescription.textColor = .label
        lbAssetDescription.font = UIFont.systemFont(ofSize: 16.0)
        lbAssetDescription.textAlignment = .left
        
        self.vAsset?.addSubview(lbAssetDescription)
        
        let lbAssetComment = UILabel()
        lbAssetComment.translatesAutoresizingMaskIntoConstraints = false
        lbAssetComment.text = "asset_message_verify_coinlive".localized()
        lbAssetComment.textColor = .assetComment
        lbAssetComment.font = UIFont.systemFont(ofSize: 12.0)
        lbAssetComment.textAlignment = .left
        
        self.vAsset?.addSubview(lbAssetComment)
        
        if let vAsset = self.vAsset {
            NSLayoutConstraint.activate([
                ivAssetIcon.leadingAnchor.constraint(equalTo: vAsset.leadingAnchor, constant: 12.0),
                ivAssetIcon.topAnchor.constraint(equalTo: vAsset.topAnchor, constant: 6.0),
                ivAssetIcon.widthAnchor.constraint(equalToConstant: self.assetIconSize),
                ivAssetIcon.heightAnchor.constraint(equalToConstant: self.assetIconSize),
                
                lbAssetName.leadingAnchor.constraint(equalTo: ivAssetIcon.trailingAnchor, constant: 4.0),
                lbAssetName.centerYAnchor.constraint(equalTo: ivAssetIcon.centerYAnchor),
                
                lbAssetDescription.topAnchor.constraint(equalTo: ivAssetIcon.bottomAnchor, constant: 8.0),
                lbAssetDescription.leadingAnchor.constraint(equalTo: ivAssetIcon.leadingAnchor),
                
                ivExchange.leadingAnchor.constraint(equalTo: lbAssetDescription.trailingAnchor, constant: 4.0),
                ivExchange.centerYAnchor.constraint(equalTo: lbAssetDescription.centerYAnchor),
                ivExchange.widthAnchor.constraint(equalToConstant: 16.0),
                ivExchange.heightAnchor.constraint(equalToConstant: 16.0),
                
                lbAssetComment.topAnchor.constraint(equalTo: lbAssetDescription.bottomAnchor, constant: 12.0),
                lbAssetComment.leadingAnchor.constraint(equalTo: ivAssetIcon.leadingAnchor),
                lbAssetComment.trailingAnchor.constraint(equalTo: vAsset.trailingAnchor, constant: -4.0)
            ])
        }
        
        if self.isBlockUser {
            self.vAsset?.isHidden = true
            self.tvMessage?.text = "message_blocked_user".localized()
            self.tvMessage?.sizeToFit()
        } else {
            if let message = chat.koMessage {
                if message.count > 400 {
                    self.tvMessage?.text = message.prefix(397).appending("...\n\n")
                } else {
                    self.tvMessage?.text = message
                }
            }
            self.vAsset?.isHidden = false
            if let asset = chat.asset {
                guard let url = NSURL(string: asset.iconUrl) else {
                    return }
                
                ImageCache.shared.load(url: url, completion: { (fetchImage) in
                    guard let fetchImage = fetchImage else {
                        return
                    }
                    let resizeImage: UIImage
                    if fetchImage.size.width > fetchImage.size.height {
                        resizeImage = fetchImage.resizeWithWidth(newWidth: 24)
                    } else {
                        resizeImage = fetchImage.resizeWithHeight(newHeight: 24)
                    }
                    ivAssetIcon.image = resizeImage
                })
                
                lbAssetName.text = asset.symbol
                lbAssetDescription.text = "$\(asset.symbol) \(asset.amount) ($\(String(format: "%.2f", asset.priceDol)))"
                let exchange = asset.exchange
                DispatchQueue.main.async {
                    if exchange == "UPBIT" {
                        ivExchange.image = .iconUpbit
                    } else if exchange == "BINANCE" {
                        ivExchange.image = .iconBinance
                    } else if exchange == "BITHUMB" {
                        ivExchange.image = .iconBithumb
                    } else if exchange == "COINONE" {
                        ivExchange.image = .iconCoinone
                    } else if exchange == "METAKMASK" {
                        ivExchange.image = .iconMetamask
                    }
                }
            }
        }
        
        self.tvMessage?.transform = CGAffineTransform.init(scaleX: 1.01, y: 1.01)
        UIView.animate(withDuration: 0.3, animations: {
            self.tvMessage?.transform = .identity
            self.tvMessage?.layoutIfNeeded()
        })
        
        let contentSize = size.height + (marginBetweenView * 2) + self.emojiViewSize.height + self.assetViewHeight + self.menuViewSize3.height + 30.0
        self.createNoCopyNoDeleteMenuViews(position: CGPoint(x: position.x, y: position.y), height: size.height + self.assetViewHeight, isReversed: (position.y + contentSize) > baseViewHeight)
    }
    
    private func createMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var emojiViewY: CGFloat
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - self.emojiViewSize.height - (self.marginBetweenView * 2) - self.menuViewSize.height
            emojiViewY = menuViewY + self.menuViewSize.height + self.marginBetweenView
            if menuViewY < topPadding {
                menuViewY = topPadding
                emojiViewY = menuViewY + self.menuViewSize.height + self.marginBetweenView
            } else {
                emojiViewY = position.y - self.emojiViewSize.height - self.marginBetweenView
            }
        } else {
            emojiViewY = position.y + height + self.marginBetweenView
            menuViewY = position.y + height + (self.marginBetweenView * 2) + self.emojiViewSize.height
        }
        self.createEmojiView(origin: CGPoint(x: position.x, y: emojiViewY))
        self.createMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createNoCopyMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var emojiViewY: CGFloat
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - self.emojiViewSize.height - (self.marginBetweenView * 2) - self.menuViewSize4.height
            if menuViewY < topPadding {
                menuViewY = topPadding
                emojiViewY = menuViewY + self.menuViewSize4.height + self.marginBetweenView
            } else {
                emojiViewY = position.y - self.emojiViewSize.height - self.marginBetweenView
            }
        } else {
            emojiViewY = position.y + height + self.marginBetweenView
            menuViewY = position.y + height + (self.marginBetweenView * 2) + self.emojiViewSize.height
        }
        self.createEmojiView(origin: CGPoint(x: position.x, y: emojiViewY))
        self.createNoCopyMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createAnonymousMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - (self.marginBetweenView * 2) - self.menuViewSize2.height
            if menuViewY < topPadding {
                menuViewY = topPadding
            }
        } else {
            menuViewY = position.y + height + (self.marginBetweenView * 2)
        }
        self.createNoBlockNoReportNoCopyMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createNoDeleteMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var emojiViewY: CGFloat
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - self.emojiViewSize.height - (self.marginBetweenView * 2) - self.menuViewSize4.height
            if menuViewY < topPadding {
                menuViewY = topPadding
                emojiViewY = menuViewY + self.menuViewSize4.height + self.marginBetweenView
            } else {
                emojiViewY = position.y - self.emojiViewSize.height - self.marginBetweenView
            }
        } else {
            emojiViewY = position.y + height + self.marginBetweenView
            menuViewY = position.y + height + (self.marginBetweenView * 2) + self.emojiViewSize.height
        }
        self.createEmojiView(origin: CGPoint(x: position.x, y: emojiViewY))
        self.createNoDeleteMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createNoCopyNoDeleteMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var emojiViewY: CGFloat
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - self.emojiViewSize.height - (self.marginBetweenView * 2) - self.menuViewSize3.height
            if menuViewY < topPadding {
                menuViewY = topPadding
                emojiViewY = menuViewY + self.menuViewSize3.height + self.marginBetweenView
            } else {
                emojiViewY = position.y - self.emojiViewSize.height - self.marginBetweenView
            }
        } else {
            emojiViewY = position.y + height + self.marginBetweenView
            menuViewY = position.y + height + (self.marginBetweenView * 2) + self.emojiViewSize.height
        }
        self.createEmojiView(origin: CGPoint(x: position.x, y: emojiViewY))
        self.createNoCopyNoDeleteMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createNoBlockNoReportMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - (self.marginBetweenView * 2) - self.menuViewSize3.height
            if menuViewY < topPadding {
                menuViewY = topPadding
            }
        } else {
            menuViewY = position.y + height + (self.marginBetweenView * 2)
        }
        self.createNoBlockNoReportMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    private func createNoBlockNoReportNoCopyMenuViews(position: CGPoint, height: CGFloat, isReversed: Bool = false) {
        var emojiViewY: CGFloat
        var menuViewY: CGFloat
        var topPadding: CGFloat = 0.0
        if let window = UIApplication.shared.windows.first {
            topPadding = window.safeAreaInsets.top
        }
        if isReversed {
            menuViewY = position.y - self.emojiViewSize.height - (self.marginBetweenView * 2) - self.menuViewSize.height
            if menuViewY < topPadding {
                menuViewY = topPadding
                emojiViewY = menuViewY + self.menuViewSize.height + self.marginBetweenView
            } else {
                emojiViewY = position.y - self.emojiViewSize.height - self.marginBetweenView
            }
        } else {
            emojiViewY = position.y + height + self.marginBetweenView
            menuViewY = position.y + height + (self.marginBetweenView * 2) + self.emojiViewSize.height
        }
        self.createEmojiView(origin: CGPoint(x: position.x, y: emojiViewY))
        self.createNoBlockNoReportNoCopyMenuView(origin: CGPoint(x: position.x, y: menuViewY))
    }
    
    internal func createEmojiView(origin: CGPoint) {
        let emojiView = UIView(frame: CGRect(origin: origin, size: self.emojiViewSize))
        emojiView.backgroundColor = .backgroundPopup
        emojiView.clipsToBounds = true
        emojiView.layer.cornerRadius = 20.0
        emojiView.layer.borderColor = UIColor.borderMenu.cgColor
        emojiView.layer.borderWidth = 0.5
        self.addSubview(emojiView)
        
        let btnGood = createEmojiBtn(emoji: .good, selector: #selector(self.clickEmojiGood))
        let btnHeart = createEmojiBtn(emoji: .heart, selector: #selector(self.clickEmojiHeart))
        let btnClap = createEmojiBtn(emoji: .clap, selector: #selector(self.clickEmojiClap))
        let btnRocket = createEmojiBtn(emoji: .rocket, selector: #selector(self.clickEmojiRocket))
        let btnAstonished = createEmojiBtn(emoji: .astonished, selector: #selector(self.clickEmojiAstonished))
        let btnCry = createEmojiBtn(emoji: .cry, selector: #selector(self.clickEmojiCry))
        
        emojiView.addSubview(btnGood)
        emojiView.addSubview(btnHeart)
        emojiView.addSubview(btnClap)
        emojiView.addSubview(btnRocket)
        emojiView.addSubview(btnAstonished)
        emojiView.addSubview(btnCry)
        
        if let emoji = self.chat?.emoji {
            emoji.forEach { (key, value) in
                switch key {
                    
                case EMOJI_TYPE.CLAP.stringValue:
                    btnClap.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                case EMOJI_TYPE.CRY.stringValue:
                    btnCry.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                case EMOJI_TYPE.ASTONISHED.stringValue:
                    btnAstonished.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                case EMOJI_TYPE.ROCKET.stringValue:
                    btnRocket.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                case EMOJI_TYPE.HEART.stringValue:
                    btnHeart.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                case EMOJI_TYPE.GOOD.stringValue:
                    btnGood.isHighlighted = value.mIds.contains(self.memberId ?? "")
                    break
                default:
                    break
                }
            }
        }
        
        NSLayoutConstraint.activate([
            btnGood.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnGood.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnGood.leadingAnchor.constraint(lessThanOrEqualTo: emojiView.leadingAnchor, constant: 16.0),
            btnGood.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            btnHeart.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnHeart.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnHeart.leadingAnchor.constraint(equalTo: btnGood.trailingAnchor, constant: 8.0),
            btnHeart.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            btnClap.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnClap.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnClap.leadingAnchor.constraint(equalTo: btnHeart.trailingAnchor, constant: 8.0),
            btnClap.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            btnRocket.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnRocket.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnRocket.leadingAnchor.constraint(equalTo: btnClap.trailingAnchor, constant: 8.0),
            btnRocket.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            btnAstonished.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnAstonished.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnAstonished.leadingAnchor.constraint(equalTo: btnRocket.trailingAnchor, constant: 8.0),
            btnAstonished.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            btnCry.widthAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnCry.heightAnchor.constraint(equalToConstant: self.emojiBtnSize),
            btnCry.leadingAnchor.constraint(equalTo: btnAstonished.trailingAnchor, constant: 8.0),
            btnCry.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            btnCry.trailingAnchor.constraint(lessThanOrEqualTo: emojiView.trailingAnchor, constant: 16.0)
        ])
    }
    
    private func createEmojiBtn(emoji: UIImage, selector: Selector) -> UIButton {
        let emojiBtn = UIButton(type: .custom)
        emojiBtn.translatesAutoresizingMaskIntoConstraints = false
        emojiBtn.setImage(emoji, for: .normal)
        emojiBtn.setImage(emoji, for: .highlighted)
        emojiBtn.setBackgroundImage(.pressed, for: .highlighted)
        emojiBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        return emojiBtn
    }
    
    internal func createNoCopyNoDeleteMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize3))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let reportLine = createMenuLineView(title: "menu_report".localized(), tColor: .label, icon: .report, selector: #selector(self.clickReport))
        let blockLine = createMenuLineView(title: self.isBlockUser ? "menu_unblock".localized() : "menu_block".localized(), tColor: .label, icon: .block, selector: #selector(self.clickBlock))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(reportLine)
        menuView.addSubview(blockLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            reportLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            reportLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            reportLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            reportLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            blockLine.topAnchor.constraint(equalTo: reportLine.bottomAnchor),
            blockLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            blockLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            blockLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: blockLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createNoBlockNoReportMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize3))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let copyLine = createMenuLineView(title: "menu_copy".localized(), tColor: .label, icon: .copy, selector: #selector(self.clickCopy))
        let deleteLine = createMenuLineView(title: "menu_delete".localized(), tColor: .labelMenuWarning, icon: nil, selector: #selector(self.clickDelete))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(copyLine)
        menuView.addSubview(deleteLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            copyLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            copyLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            copyLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            copyLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            deleteLine.topAnchor.constraint(equalTo: copyLine.bottomAnchor),
            deleteLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            deleteLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            deleteLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: deleteLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createNoBlockNoReportNoCopyMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize2))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let copyLine = createMenuLineView(title: "menu_copy".localized(), tColor: .label, icon: .copy, selector: #selector(self.clickCopy))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(copyLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            copyLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            copyLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            copyLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            copyLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: copyLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createNoBlockNoDeleteNoReportMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize2))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let deleteLine = createMenuLineView(title: "menu_delete".localized(), tColor: .labelMenuWarning, icon: nil, selector: #selector(self.clickDelete))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(deleteLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            deleteLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            deleteLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            deleteLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            deleteLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: deleteLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createNoCopyMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize4))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let reportLine = createMenuLineView(title: "menu_report".localized(), tColor: .label, icon: .report, selector: #selector(self.clickReport))
        let blockLine = createMenuLineView(title: self.isBlockUser ? "menu_unblock".localized() : "menu_block".localized(), tColor: .label, icon: .block, selector: #selector(self.clickBlock))
        let deleteLine = createMenuLineView(title: "menu_delete".localized(), tColor: .labelMenuWarning, icon: nil, selector: #selector(self.clickDelete))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(reportLine)
        menuView.addSubview(blockLine)
        menuView.addSubview(deleteLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            reportLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            reportLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            reportLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            reportLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            blockLine.topAnchor.constraint(equalTo: reportLine.bottomAnchor),
            blockLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            blockLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            blockLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            deleteLine.topAnchor.constraint(equalTo: blockLine.bottomAnchor),
            deleteLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            deleteLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            deleteLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: deleteLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createNoDeleteMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize4))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let copyLine = createMenuLineView(title: "menu_copy".localized(), tColor: .label, icon: .copy, selector: #selector(self.clickCopy))
        let reportLine = createMenuLineView(title: "menu_report".localized(), tColor: .label, icon: .report, selector: #selector(self.clickReport))
        let blockLine = createMenuLineView(title: self.isBlockUser ? "menu_unblock".localized() : "menu_block".localized(), tColor: .label, icon: .block, selector: #selector(self.clickBlock))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(copyLine)
        menuView.addSubview(reportLine)
        menuView.addSubview(blockLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            copyLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            copyLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            copyLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            copyLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            reportLine.topAnchor.constraint(equalTo: copyLine.bottomAnchor),
            reportLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            reportLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            reportLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            blockLine.topAnchor.constraint(equalTo: reportLine.bottomAnchor),
            blockLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            blockLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            blockLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: blockLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    internal func createMenuView(origin: CGPoint) {
        let menuView = UIView(frame: CGRect(origin: origin, size: self.menuViewSize))
        menuView.backgroundColor = .backgroundPopup
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 6.0
        menuView.layer.borderColor = UIColor.borderMenu.cgColor
        menuView.layer.borderWidth = 0.5
        
        let copyLine = createMenuLineView(title: "menu_copy".localized(), tColor: .label, icon: .copy, selector: #selector(self.clickCopy))
        let reportLine = createMenuLineView(title: "menu_report".localized(), tColor: .label, icon: .report, selector: #selector(self.clickReport))
        let blockLine = createMenuLineView(title: self.isBlockUser ? "menu_unblock".localized() : "menu_block".localized(), tColor: .label, icon: .block, selector: #selector(self.clickBlock))
        let deleteLine = createMenuLineView(title: "menu_delete".localized(), tColor: .labelMenuWarning, icon: nil, selector: #selector(self.clickDelete))
        let cancelLine = createMenuLineView(title: "menu_cancel".localized(), tColor: .labelMenuWarning, icon: nil, isAddBorder: false, selector: #selector(self.closeMenu))
        
        menuView.addSubview(copyLine)
        menuView.addSubview(reportLine)
        menuView.addSubview(blockLine)
        menuView.addSubview(deleteLine)
        menuView.addSubview(cancelLine)
        
        NSLayoutConstraint.activate([
            copyLine.topAnchor.constraint(equalTo: menuView.topAnchor),
            copyLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            copyLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            copyLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            reportLine.topAnchor.constraint(equalTo: copyLine.bottomAnchor),
            reportLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            reportLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            reportLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            blockLine.topAnchor.constraint(equalTo: reportLine.bottomAnchor),
            blockLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            blockLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            blockLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            deleteLine.topAnchor.constraint(equalTo: blockLine.bottomAnchor),
            deleteLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            deleteLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            deleteLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
            
            cancelLine.topAnchor.constraint(equalTo: deleteLine.bottomAnchor),
            cancelLine.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            cancelLine.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            cancelLine.heightAnchor.constraint(equalToConstant: self.menuLineHeight),
        ])
        
        self.addSubview(menuView)
    }
    
    private func createMenuLineView(title: String, tColor: UIColor, icon: UIImage?, isAddBorder: Bool = true, selector: Selector) -> UIView {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.isUserInteractionEnabled = true
        lineView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        
        let lbTitle = UILabel()
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.textColor = tColor
        lbTitle.font = UIFont.systemFont(ofSize: 14.0)
        lbTitle.text = title
        
        lineView.addSubview(lbTitle)
        
        let ivIcon = UIImageView()
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        ivIcon.image = icon
        
        lineView.addSubview(ivIcon)
        
        NSLayoutConstraint.activate([
            lbTitle.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16.0),
            lbTitle.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            ivIcon.widthAnchor.constraint(equalToConstant: self.menuIconSize),
            ivIcon.heightAnchor.constraint(equalToConstant: self.menuIconSize),
            ivIcon.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            ivIcon.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16.0)
        ])
        if isAddBorder {
            let vDivider = UIView()
            vDivider.backgroundColor = .borderMenu
            vDivider.translatesAutoresizingMaskIntoConstraints = false
            lineView.addSubview(vDivider)
            NSLayoutConstraint.activate([
                vDivider.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
                vDivider.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
                vDivider.heightAnchor.constraint(equalToConstant: 1),
                vDivider.widthAnchor.constraint(equalTo: lineView.widthAnchor),
                vDivider.bottomAnchor.constraint(equalTo: lineView.bottomAnchor)
            ])
        }
        
        return lineView
    }
    
    @objc func clickEmojiGood() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.GOOD.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.GOOD)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.GOOD)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.GOOD)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.GOOD)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickEmojiHeart() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.HEART.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.HEART)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.HEART)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.HEART)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.HEART)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickEmojiClap() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.CLAP.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.CLAP)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.CLAP)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.CLAP)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.CLAP)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickEmojiRocket() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.ROCKET.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.ROCKET)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.ROCKET)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.ROCKET)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.ROCKET)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickEmojiAstonished() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.ASTONISHED.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.ASTONISHED)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.ASTONISHED)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.ASTONISHED)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.ASTONISHED)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickEmojiCry() {
        guard let memberId = self.memberId else { return }
        if let emoji = self.chat?.emoji {
            if let item = emoji[EMOJI_TYPE.CRY.stringValue] {
                if item.mIds.contains(memberId) {
                    self.floatMenuActionDelegate?.deleteEmojiAction(.CRY)
                } else {
                    self.floatMenuActionDelegate?.emojiAction(.CRY)
                }
            } else {
                self.floatMenuActionDelegate?.emojiAction(.CRY)
            }
        } else {
            self.floatMenuActionDelegate?.emojiAction(.CRY)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickCopy() {
        self.floatMenuActionDelegate?.copy()
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickReport() {
        if let chat = self.chat {
            self.menuViewActionDelegate?.showReportAlert(chat: chat)
        }
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickBlock() {
        self.menuViewActionDelegate?.showAlert(description: self.isBlockUser ? "message_unblock_description".localized() : "message_block_description".localized(),
                                               confirmText: self.isBlockUser ? "menu_unblock".localized() : "menu_block".localized(),
                                               cancelText: "common_cancel".localized(),
                                               eCallback: {
            self.floatMenuActionDelegate?.block()
        })
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func clickDelete() {
        self.menuViewActionDelegate?.showAlert(description: "message_delete_description".localized(),
                                               confirmText: "message_delete_confirm".localized(),
                                               cancelText: "common_cancel".localized(),
                                               eCallback: {
            self.floatMenuActionDelegate?.delete()
        })
        self.menuViewActionDelegate?.closeMenu()
    }
    
    @objc func closeMenu() {
        self.menuViewActionDelegate?.closeMenu()
    }
    @objc func closeChatMenu() {
        self.menuViewActionDelegate?.closeMenu()
    }
}

extension FloatChatMenuView: MenuViewDelegate {
    func deletedMessage(messageId: String?, callback: @escaping (Bool) -> ()) {
        if self.chat?.messageId == messageId {
            self.removeFromSuperview()
            callback(true)
        } else {
            callback(false)
        }
    }
}

extension FloatChatMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let images = chat?.images {
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

extension FloatChatMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if let images = self.chat?.images {
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
                    ImageCache.shared.load(url: url, completion: { (fetchImage) in
                        guard let fetchImage = fetchImage else {
                            cell.prepare(image: .imgLoadFailed)
                            return
                        }
                        
                        guard let croppedImage = fetchImage.centerCrop() else {
                            cell.prepare(image: .imgLoadFailed)
                            return
                        }
                        DispatchQueue.main.async {
                            cell.prepare(image: croppedImage)
                        }
                    })
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = chat?.images {
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
        if let images = chat?.images {
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
