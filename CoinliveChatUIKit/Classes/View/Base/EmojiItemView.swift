//
//  EmojiItemView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/07.
//

import UIKit
import CoinliveChatSDK

class EmojiItemView: UIView {
    internal var count: Int = 0
    internal var emojiType: String = ""
    internal var isSelect: Bool = false
    private weak var ivEmoji: UIImageView?
    private weak var lbCount: UILabel?
    
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
        backgroundColor = .backgroundEmoji
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 11
        
        let ivEmoji = UIImageView()
        ivEmoji.translatesAutoresizingMaskIntoConstraints = false
        ivEmoji.image = .cry
        
        
        let lbCount = UILabel()
        lbCount.textColor = .label
        lbCount.font = UIFont.systemFont(ofSize: 10)
        lbCount.textAlignment = .center
        lbCount.adjustsFontSizeToFitWidth = true
        lbCount.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(ivEmoji)
        self.addSubview(lbCount)
        self.ivEmoji = ivEmoji
        self.lbCount = lbCount
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 45.0),
            self.heightAnchor.constraint(equalToConstant: 23.0),
            self.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            ivEmoji.widthAnchor.constraint(equalToConstant: 15.0),
            ivEmoji.heightAnchor.constraint(equalToConstant: 15.0),
            
            ivEmoji.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ivEmoji.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7.0),
            lbCount.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lbCount.leadingAnchor.constraint(lessThanOrEqualTo: ivEmoji.trailingAnchor, constant: 5.0),
            lbCount.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7.0)
        ])
    }
    
    internal func loadEmoji(count: Int, emojiType: String, isSelect: Bool) {
        self.count = count
        self.emojiType = emojiType
        self.isSelect = isSelect
        self.ivEmoji?.image = self.getEmojiImage(type: emojiType)
        self.lbCount?.text = self.countCheck(count: count)
        self.lbCount?.sizeToFit()
        
        if isSelect {
            self.layer.borderColor = UIColor.primary.cgColor
            self.layer.borderWidth = 1.0
            self.lbCount?.textColor = .primary
        } else {
            self.layer.borderWidth = 0.0
            self.lbCount?.textColor = .label
        }
    }
    
    private func countCheck(count: Int) -> String {
        let k = count / 1000
        
        if k > 0 {
            return "\(k)k"
        }
        return "\(count)"
    }
    
    private func getEmojiImage(type: String) -> UIImage {
        switch type {
        case EMOJI_TYPE.CLAP.stringValue:
            return .clap
        case EMOJI_TYPE.CRY.stringValue:
            return .cry
        case EMOJI_TYPE.ASTONISHED.stringValue:
            return .astonished
        case EMOJI_TYPE.ROCKET.stringValue:
            return .rocket
        case EMOJI_TYPE.HEART.stringValue:
            return .heart
        case EMOJI_TYPE.GOOD.stringValue:
            return .good
        default:
            return .good
        }
    }
    
}
