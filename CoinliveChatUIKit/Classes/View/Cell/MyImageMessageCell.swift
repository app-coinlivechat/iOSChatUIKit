//
//  MyImageMessageCell.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/22.
//

import UIKit
import CoinliveChatSDK

class MyImageMessageCell: UITableViewCell {
    internal weak var messageCellDelegate: MessageCellDelegate? = nil
    internal weak var floatMenuDelegate: FloatMenuDelegate? = nil
    private var chat: Chat!
    private weak var ivSingle: UIImageView!
    private weak var lbDate: UILabel!
    private weak var emojiView: UIView!
    private weak var messageDateView: MessageDateView?
    
    private var targetImage: UIImage? = nil
    
    private weak var contentTopConstraint: NSLayoutConstraint? = nil
    private weak var ivWidthSizeConstraint: NSLayoutConstraint? = nil
    private weak var ivHeightSizeConstraint: NSLayoutConstraint? = nil
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initializeUi()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        
        let ivSingle = UIImageView()
        ivSingle.translatesAutoresizingMaskIntoConstraints = false
        ivSingle.clipsToBounds = true
        ivSingle.layer.cornerRadius = 6.0
        ivSingle.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,. layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.addSubview(ivSingle)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressContent))
        longPress.minimumPressDuration = 1
        ivSingle.isUserInteractionEnabled = true
        ivSingle.addGestureRecognizer(longPress)
        
        self.ivSingle = ivSingle
        
        let lbDate = UILabel()
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.font = UIFont.systemFont(ofSize: 12)
        lbDate.textColor = .labelMessageDate
        lbDate.textAlignment = .left
        
        self.addSubview(lbDate)
        self.lbDate = lbDate
        
        NSLayoutConstraint.activate([
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            ivSingle.topAnchor.constraint(equalTo: messageDateView.topAnchor),
            ivSingle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            ivSingle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0),
            
            lbDate.trailingAnchor.constraint(equalTo: ivSingle.leadingAnchor, constant: -4.0),
            lbDate.bottomAnchor.constraint(equalTo: ivSingle.bottomAnchor),
        ])
        
        self.ivWidthSizeConstraint = ivSingle.widthAnchor.constraint(lessThanOrEqualToConstant: 241)
        self.ivHeightSizeConstraint = ivSingle.heightAnchor.constraint(lessThanOrEqualToConstant: 241)
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        self.ivWidthSizeConstraint?.isActive = true
        self.ivHeightSizeConstraint?.isActive = true
        self.contentTopConstraint = messageDateView.topAnchor.constraint(equalTo: self.topAnchor)
        self.contentTopConstraint?.isActive = true
        self.dateViewHeightConstraint?.isActive = true
    }
    
    internal func resizeImageViewHeight(image: UIImage, height: CGFloat) {
        self.ivHeightSizeConstraint?.constant = height / 1440 * 241
        self.targetImage = image
        self.ivSingle?.image = image
        self.ivSingle?.layoutIfNeeded()
    }
    
    internal func resizeImageViewWidth(image: UIImage, width: CGFloat) {
        self.ivWidthSizeConstraint?.constant = width / 1440 * 241
        self.targetImage = image
        self.ivSingle?.image = image
        self.ivSingle?.layoutIfNeeded()
    }
    
    @objc func pressContent(_ recogizer: UILongPressGestureRecognizer) {
        guard let ivSingle = self.ivSingle else { return }
        if recogizer.state == .began {
            let point = CGPoint(x: self.frame.origin.x + ivSingle.frame.origin.x, y: self.frame.origin.y + ivSingle.frame.origin.y)
            if let convertPoint = self.superview?.convert(point, to: nil), let image = self.targetImage {
                self.floatMenuDelegate?.loadImageMenu(floatMenuActionDelegate: self,
                                                      position: convertPoint,
                                                      isMyMessage: true,
                                                      image: image,
                                                      chat: self.chat, isBlockUser: false)
            }
        }
    }
    
    internal func loadFailed() {
        let image: UIImage = .imgLoadFailed
        self.ivSingle?.image = image
        self.ivWidthSizeConstraint?.constant = image.size.width
        self.ivHeightSizeConstraint?.constant = image.size.height
        self.ivSingle?.contentMode = .scaleAspectFit
        self.ivSingle?.layoutIfNeeded()
    }
    
    internal func loadData(chat: Chat, isHideDate: Bool, isHeadMessage: Bool, isFirstMessage: Bool, isSameDayPreviousMessage: Bool, memberId: String?) {
        self.chat = chat
        self.lbDate?.isHidden = isHideDate
        if !isHideDate {
            self.lbDate?.text = chat.insertTime.convertDateFormat(form: "a hh:mm", locale: .current)
        }
        
        if isSameDayPreviousMessage {
            self.messageDateView?.isHidden = true
            self.dateViewHeightConstraint?.constant = 0.0
        } else {
            self.messageDateView?.setUpData(date: chat.insertTime.convertTableKey())
            self.messageDateView?.isHidden = false
            self.dateViewHeightConstraint?.constant = 52.0
        }
        
        if isFirstMessage {
            self.contentTopConstraint?.constant = 0.0
        } else {
            self.contentTopConstraint?.constant = 4.0
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension MyImageMessageCell: FloatMenuActionDelegate {
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
        
    }
    
    func delete() {
        self.messageCellDelegate?.deleteMessage(chat: self.chat)
        
    }
    
    func report() {
        
    }
}
