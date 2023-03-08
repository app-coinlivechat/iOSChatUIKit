//
//  ServerMessageView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//

import UIKit
import CoinliveChatSDK

class ServerMessageCell: UITableViewCell {
    private var chat: Chat!
    private var channel: Channel!
    private weak var ivIcon: UIImageView?
    private weak var lbTitle: UILabel?
    private weak var lbContent: UILabel?
    private weak var lbDate: UILabel?
    private weak var messageDateView: MessageDateView?
    private weak var dateViewHeightConstraint: NSLayoutConstraint?
    
    private let iconSize: CGFloat = 18.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func initializeUi() {
        selectionStyle = .none
        
        let messageDateView = MessageDateView()
        messageDateView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageDateView)
        self.messageDateView = messageDateView
        
        let vBackground = UIView()
        vBackground.translatesAutoresizingMaskIntoConstraints = false
        vBackground.backgroundColor = .boxMessageSystem
        self.contentView.addSubview(vBackground)
        
        let ivIcon = UIImageView()
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ivIcon)
        self.ivIcon = ivIcon
        
        let lbTitle = UILabel()
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.textColor = .label
        lbTitle.font = UIFont.systemFont(ofSize: 14)
        lbTitle.textAlignment = .left
        addSubview(lbTitle)
        self.lbTitle = lbTitle
        
        let lbContent = UILabel()
        lbContent.translatesAutoresizingMaskIntoConstraints = false
        lbContent.numberOfLines = 2
        lbContent.textColor = .labelSystem
        lbContent.font = UIFont.systemFont(ofSize: 12)
        lbContent.textAlignment = .left
        addSubview(lbContent)
        self.lbContent = lbContent
        
        let lbDate = UILabel()
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.font = UIFont.systemFont(ofSize: 12)
        lbDate.textColor = .labelMessageDate
        lbDate.textAlignment = .left
        addSubview(lbDate)
        self.lbDate = lbDate
        
        NSLayoutConstraint.activate([
            messageDateView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            messageDateView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            vBackground.topAnchor.constraint(equalTo: messageDateView.bottomAnchor),
            vBackground.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            vBackground.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            vBackground.heightAnchor.constraint(equalToConstant: 54.0),
            vBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            
            ivIcon.topAnchor.constraint(equalTo: vBackground.topAnchor, constant: 8.0),
            ivIcon.leadingAnchor.constraint(equalTo: vBackground.leadingAnchor, constant: 16.0),
            ivIcon.widthAnchor.constraint(equalToConstant: self.iconSize),
            ivIcon.heightAnchor.constraint(equalToConstant: self.iconSize),
            
            lbTitle.topAnchor.constraint(equalTo: ivIcon.topAnchor),
            lbTitle.leadingAnchor.constraint(equalTo: ivIcon.trailingAnchor, constant: 6.0),
            lbTitle.trailingAnchor.constraint(equalTo: vBackground.trailingAnchor, constant: -8.0),
            
            lbContent.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: 2.0),
            lbContent.leadingAnchor.constraint(equalTo: lbTitle.leadingAnchor),
            lbContent.bottomAnchor.constraint(equalTo: vBackground.bottomAnchor, constant: -8.0),
            lbContent.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
            
            lbDate.trailingAnchor.constraint(equalTo: vBackground.trailingAnchor, constant: -16.0),
            lbDate.bottomAnchor.constraint(equalTo: lbContent.bottomAnchor)
        ])
        
        self.dateViewHeightConstraint = messageDateView.heightAnchor.constraint(equalToConstant: 52.0)
        self.dateViewHeightConstraint?.isActive = true
    }
    
    internal func loadData(chat: Chat, isSameDayPreviousMessage: Bool, channel: Channel) {
        self.chat = chat
        self.channel = channel
        self.ivIcon?.image = getIconImage(type: chat.messageType.uppercased())
        self.lbTitle?.text = getTitle(type: chat.messageType.uppercased())
        self.lbContent?.text = chat.koMessage
        self.lbDate?.text = chat.insertTime.convertDateFormat(form: "a hh:mm", locale: .current)
        
        if isSameDayPreviousMessage {
            self.messageDateView?.isHidden = true
            self.dateViewHeightConstraint?.constant = 0.0
        } else {
            self.messageDateView?.setUpData(date: chat.insertTime.convertTableKey())
            self.messageDateView?.isHidden = false
            self.dateViewHeightConstraint?.constant = 52.0
        }
        
        self.layoutIfNeeded()
    }
    
    private func getIconImage(type: String) -> UIImage {
        if type == MESSAGE_TYPE.JUMP.name.uppercased() || type == MESSAGE_TYPE.DROP.name.uppercased() {
            return .jumpAndDrop
        } else if type == MESSAGE_TYPE.TWITTER.name.uppercased() {
            return .twitter
        } else if type == MESSAGE_TYPE.BUY.name.uppercased() || type == MESSAGE_TYPE.SELL.name.uppercased() {
            return .binance
        } else if type == MESSAGE_TYPE.MEDIUM.name.uppercased() {
            return .medium
        } else {
            fatalError("No type \(type)")
        }
    }
    
    private func getTitle(type: String) -> String {
        if type == MESSAGE_TYPE.JUMP.name.uppercased() {
            return "system_message_jump".localized()
        } else if type == MESSAGE_TYPE.DROP.name.uppercased() {
            return "system_message_drop".localized()
        } else if type == MESSAGE_TYPE.TWITTER.name.uppercased() {
            return "system_message_twitter".localized(with: self.channel.name!, self.channel.symbol!)
        } else if type == MESSAGE_TYPE.BUY.name.uppercased() {
            return "system_message_long".localized()
        } else if type == MESSAGE_TYPE.SELL.name.uppercased() {
            return "system_message_short".localized()
        } else if type == MESSAGE_TYPE.MEDIUM.name.uppercased() {
            return "system_message_medium".localized(with: self.channel.name!, self.channel.symbol!)
        } else {
            fatalError("No type")
        }
    }
}
