//
//  EmojiView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/07.
//

import UIKit
import CoinliveChatSDK

class EmojiView: UIView {
    private weak var svEmojiView: UIStackView?
    private var emojiMap: Dictionary<String, EmojiItemView> = [:]
    internal weak var emojiViewDelegate: EmojiViewDelegate?
    
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
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let svEmojiView = UIStackView()
        svEmojiView.translatesAutoresizingMaskIntoConstraints = false
        svEmojiView.axis = .horizontal
        svEmojiView.spacing = 2.0
        svEmojiView.alignment = .leading
        svEmojiView.distribution = .equalSpacing
        self.addSubview(svEmojiView)
        self.svEmojiView = svEmojiView
        
        NSLayoutConstraint.activate([
            svEmojiView.topAnchor.constraint(equalTo: self.topAnchor),
            svEmojiView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            svEmojiView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            svEmojiView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    internal func hideEmoji() {
        self.emojiMap.keys.forEach { key in
            let view = self.emojiMap[key]
            view?.removeFromSuperview()
            self.emojiMap.removeValue(forKey: key)
        }
    }
    
    internal func loadEmoji(emojis: Dictionary<String, Emoji>, memberId: String) {
        self.emojiMap.keys.forEach { key in
            let view = self.emojiMap[key]
            view?.removeFromSuperview()
            self.emojiMap.removeValue(forKey: key)
        }
        emojis
            .filter { $0.value.count > 0 }
            .sorted {
                $0.value.count > $1.value.count
            }
            .forEach { (key, emoji) in
                let emojiItemView = EmojiItemView()
                emojiItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickEmoji(_:))))
                emojiItemView.loadEmoji(count: emoji.count, emojiType: key, isSelect: emoji.mIds.contains(memberId))
                emojiMap[key] = emojiItemView
                self.svEmojiView?.addArrangedSubview(emojiItemView)
            }
    }
    
    @objc func clickEmoji(_ sender: UITapGestureRecognizer) {
        if let emojiItemView = sender.view as? EmojiItemView {
            if let emojiType = EMOJI_TYPE(rawValue: emojiItemView.emojiType) {
                self.emojiViewDelegate?.clickEmoji(emojiType: emojiType, isSelect: emojiItemView.isSelect)
            }
        }
    }
}
