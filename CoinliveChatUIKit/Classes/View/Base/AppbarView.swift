//
//  AppbarView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//

import UIKit
import CoinliveChatSDK

class AppbarView: UIView {
    internal weak var appbarActionDelegate: AppbarActionDelegate?
    private let channelIconSize: CGFloat = 24.0
    private let userIconSize: CGFloat = 12.0
    private let rightButtonIconSize: CGFloat = 28.0
    private let baseToolbarSize: CGFloat = 60.0
    private let moreActionAreaWidth: CGFloat = 166.0
    private let moreActionAreaHeight: CGFloat = 160.0
    private let moreActionAreaHeight2: CGFloat = 80.0
    private let moreActionLineHeight: CGFloat = 40.0
    private let moreActionButtonSize: CGFloat = 18.0
    
    private weak var ivHeaderChannelIcon: UIImageView?
    private weak var lbHeaderChannelName: UILabel?
    private weak var ivHeaderUserCountIcon: UIImageView?
    private weak var lbHeaderUserCount: UILabel?
    private weak var btnHeaderMore: UIButton?
    private weak var btnHeaderFold: UIButton?
    
    private weak var moreAreaView: UIView? = nil
    var isAnonymousUser: Bool = false 
    
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        
        let ivHeaderChannelIcon = UIImageView()
        ivHeaderChannelIcon.translatesAutoresizingMaskIntoConstraints = false
        ivHeaderChannelIcon.layer.cornerRadius = ivHeaderChannelIcon.frame.size.height / 2.0
        self.addSubview(ivHeaderChannelIcon)
        self.ivHeaderChannelIcon = ivHeaderChannelIcon
        
        ivHeaderChannelIcon.widthAnchor.constraint(equalToConstant: self.channelIconSize).isActive = true
        ivHeaderChannelIcon.heightAnchor.constraint(equalToConstant: self.channelIconSize).isActive = true
        ivHeaderChannelIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ivHeaderChannelIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
    
        let lbHeaderChannelName = UILabel()
        lbHeaderChannelName.translatesAutoresizingMaskIntoConstraints = false
        lbHeaderChannelName.font = UIFont.systemFont(ofSize: 16.0)
        lbHeaderChannelName.textColor = .label
        self.addSubview(lbHeaderChannelName)
        self.lbHeaderChannelName = lbHeaderChannelName
        
        lbHeaderChannelName.leadingAnchor.constraint(equalTo: ivHeaderChannelIcon.trailingAnchor, constant: 6.0).isActive = true
        lbHeaderChannelName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let btnHeaderFold = UIButton(type: .custom)
        btnHeaderFold.translatesAutoresizingMaskIntoConstraints = false
        btnHeaderFold.setImage(.fold, for: .normal)
        btnHeaderFold.addTarget(self, action: #selector(actionFold), for: .touchUpInside)
        self.addSubview(btnHeaderFold)
        self.btnHeaderFold = btnHeaderFold
        
        let btnHeaderMore = UIButton(type: .custom)
        btnHeaderMore.translatesAutoresizingMaskIntoConstraints = false
        btnHeaderMore.setImage(.more, for: .normal)
        btnHeaderMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        
        self.addSubview(btnHeaderMore)
        self.btnHeaderMore = btnHeaderMore
        
        let lbHeaderUserCount = UILabel()
        lbHeaderUserCount.translatesAutoresizingMaskIntoConstraints = false
        lbHeaderUserCount.textColor = .label
        lbHeaderUserCount.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(lbHeaderUserCount)
        self.lbHeaderUserCount = lbHeaderUserCount
        
        let ivHeaderUserCountIcon = UIImageView()
        ivHeaderUserCountIcon.translatesAutoresizingMaskIntoConstraints = false
        ivHeaderUserCountIcon.image = .userCount
        
        self.addSubview(ivHeaderUserCountIcon)
        self.ivHeaderUserCountIcon = ivHeaderUserCountIcon
        
        btnHeaderFold.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
        btnHeaderFold.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        btnHeaderFold.widthAnchor.constraint(equalToConstant: self.rightButtonIconSize).isActive = true
        btnHeaderFold.heightAnchor.constraint(equalToConstant: self.rightButtonIconSize).isActive = true
        
        btnHeaderMore.trailingAnchor.constraint(equalTo: btnHeaderFold.leadingAnchor, constant: -8.0).isActive = true
        btnHeaderMore.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        btnHeaderMore.widthAnchor.constraint(equalToConstant: self.rightButtonIconSize).isActive = true
        btnHeaderMore.heightAnchor.constraint(equalToConstant: self.rightButtonIconSize).isActive = true
        
        lbHeaderUserCount.trailingAnchor.constraint(equalTo: btnHeaderMore.leadingAnchor, constant: -16.0).isActive = true
        lbHeaderUserCount.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        ivHeaderUserCountIcon.trailingAnchor.constraint(equalTo: lbHeaderUserCount.leadingAnchor, constant: -8.0).isActive = true
        ivHeaderUserCountIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ivHeaderUserCountIcon.widthAnchor.constraint(equalToConstant: self.userIconSize).isActive = true
        ivHeaderUserCountIcon.heightAnchor.constraint(equalToConstant: self.userIconSize).isActive = true
    }
    
    internal func setUpData(channel: Channel, appbarActionDelegate: AppbarActionDelegate) {
        if let imageUrlString = channel.iconUrl, let imageUrl = NSURL(string: imageUrlString) {
            ImageCache.shared.load(url: imageUrl, completion: { [weak self] image in
                guard let self = self else { return }
                guard let image = image else {
                    DispatchQueue.main.async {
                        self.ivHeaderChannelIcon?.image = .block
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.ivHeaderChannelIcon?.image = image
                }
            })
        } else {
            DispatchQueue.main.async {
                self.ivHeaderChannelIcon?.image = .block
            }
        }
        self.lbHeaderChannelName?.text = channel.symbol
        self.appbarActionDelegate = appbarActionDelegate
    }
    
    private func createMoreActions() -> UIView {
        let moreView = UIView()
        moreView.translatesAutoresizingMaskIntoConstraints = false
        moreView.backgroundColor = .background
        moreView.layer.cornerRadius = 6.0
        moreView.layer.borderColor = UIColor.moreActionDivider.cgColor
        moreView.layer.borderWidth = 1.0
        
        moreView.layer.masksToBounds = false
        moreView.layer.shadowOffset = CGSize(width: 0, height: 0)
        moreView.layer.shadowRadius = 6.0
        moreView.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        moreView.layer.shadowOpacity = 4.0
        
        let shareChannel = createMoreLine(title: "appbar_menu_channel_share".localized(), icon: .share)
        shareChannel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareChannel)))
        moreView.addSubview(shareChannel)
        let translateSetting = createMoreLine(title: "appbar_menu_translation_setting".localized(), icon: .translateSetting)
        translateSetting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.settingTranslate)))
        moreView.addSubview(translateSetting)
        
        if !self.isAnonymousUser {
            let setting = createMoreLine(title: "appbar_menu_notification_setting".localized(), icon: .setting)
            setting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.settingNotification)))
            moreView.addSubview(setting)
            
            setting.topAnchor.constraint(equalTo: shareChannel.bottomAnchor).isActive = true
            setting.leadingAnchor.constraint(equalTo: moreView.leadingAnchor).isActive = true
            setting.trailingAnchor.constraint(equalTo: moreView.trailingAnchor).isActive = true
            setting.heightAnchor.constraint(equalToConstant: self.moreActionLineHeight - 1).isActive = true
            translateSetting.topAnchor.constraint(equalTo: setting.bottomAnchor).isActive = true
            
            let divider2 = CALayer()
            divider2.backgroundColor = UIColor.moreActionDivider.cgColor
            divider2.frame = CGRect(origin: CGPointMake(0, (self.moreActionLineHeight*2)), size: CGSize(width: self.moreActionAreaWidth, height: 1))
            moreView.layer.addSublayer(divider2)
            
            let profileSetting = createMoreLine(title: "appbar_menu_profile_setting".localized(), icon: .menuProfile)
            profileSetting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.settingProfile)))
            moreView.addSubview(profileSetting)
            
            profileSetting.topAnchor.constraint(equalTo: translateSetting.bottomAnchor).isActive = true
            profileSetting.leadingAnchor.constraint(equalTo: moreView.leadingAnchor).isActive = true
            profileSetting.trailingAnchor.constraint(equalTo: moreView.trailingAnchor).isActive = true
            profileSetting.heightAnchor.constraint(equalToConstant: self.moreActionLineHeight - 1).isActive = true
            
            let divider3 = CALayer()
            divider3.backgroundColor = UIColor.moreActionDivider.cgColor
            divider3.frame = CGRect(origin: CGPointMake(0, (self.moreActionLineHeight*3)), size: CGSize(width: self.moreActionAreaWidth, height: 1))
            moreView.layer.addSublayer(divider3)
            
        } else {
            translateSetting.topAnchor.constraint(equalTo: shareChannel.bottomAnchor).isActive = true
        }
        
        shareChannel.topAnchor.constraint(equalTo: moreView.topAnchor).isActive = true
        shareChannel.leadingAnchor.constraint(equalTo: moreView.leadingAnchor).isActive = true
        shareChannel.trailingAnchor.constraint(equalTo: moreView.trailingAnchor).isActive = true
        shareChannel.heightAnchor.constraint(equalToConstant: self.moreActionLineHeight - 1).isActive = true
        
        let divider = CALayer()
        divider.backgroundColor = UIColor.moreActionDivider.cgColor
        divider.frame = CGRect(origin: CGPointMake(0, self.moreActionLineHeight), size: CGSize(width: self.moreActionAreaWidth, height: 1))
        moreView.layer.addSublayer(divider)
        
        translateSetting.leadingAnchor.constraint(equalTo: moreView.leadingAnchor).isActive = true
        translateSetting.trailingAnchor.constraint(equalTo: moreView.trailingAnchor).isActive = true
        translateSetting.heightAnchor.constraint(equalToConstant: self.moreActionLineHeight).isActive = true
        
        return moreView
    }
    
    private func createMoreLine(title: String, icon: UIImage) -> UIView {
        let moreLine = UIView()
        moreLine.translatesAutoresizingMaskIntoConstraints = false
        
        let lbTitle = UILabel()
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.text = title
        lbTitle.textColor = .label
        lbTitle.textAlignment = .left
        lbTitle.font = UIFont.systemFont(ofSize: 14)
        lbTitle.adjustsFontSizeToFitWidth = true
        moreLine.addSubview(lbTitle)
        
        let ivIcon = UIImageView()
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        ivIcon.image = icon
        moreLine.addSubview(ivIcon)
        
        lbTitle.centerYAnchor.constraint(equalTo: moreLine.centerYAnchor).isActive = true
        lbTitle.leadingAnchor.constraint(equalTo: moreLine.leadingAnchor, constant: 16.0).isActive = true
        lbTitle.trailingAnchor.constraint(equalTo: ivIcon.leadingAnchor, constant: -8.0).isActive = true
        
        ivIcon.centerYAnchor.constraint(equalTo: moreLine.centerYAnchor).isActive = true
        ivIcon.trailingAnchor.constraint(equalTo: moreLine.trailingAnchor, constant: -16.0).isActive = true
        ivIcon.widthAnchor.constraint(equalToConstant: self.moreActionButtonSize).isActive = true
        ivIcon.heightAnchor.constraint(equalToConstant: self.moreActionButtonSize).isActive = true
        
        return moreLine
    }
    
    @objc func actionFold() {
        self.close()
        appbarActionDelegate?.actionFold() 
    }
    
    @objc func actionMore() {
        if let moreView = self.moreAreaView {
            moreView.removeFromSuperview()
            self.moreAreaView = nil
        } else {
            let moreAreaView = self.createMoreActions()
            if let btnHeaderMore = self.btnHeaderMore {
                window?.addSubview(moreAreaView)
                moreAreaView.widthAnchor.constraint(equalToConstant: self.moreActionAreaWidth).isActive = true
                if self.isAnonymousUser {
                    moreAreaView.heightAnchor.constraint(equalToConstant: self.moreActionAreaHeight2).isActive = true
                } else {
                    moreAreaView.heightAnchor.constraint(equalToConstant: self.moreActionAreaHeight).isActive = true
                }
                moreAreaView.centerXAnchor.constraint(equalTo: btnHeaderMore.centerXAnchor, constant: -(self.moreActionAreaWidth / 4.0)).isActive = true
                moreAreaView.topAnchor.constraint(equalTo: btnHeaderMore.bottomAnchor).isActive = true
                self.moreAreaView = moreAreaView
            }
        }
    }
    
    @objc func shareChannel() {
        if let moreView = self.moreAreaView {
            moreView.removeFromSuperview()
            self.moreAreaView = nil
            self.appbarActionDelegate?.actionChannelShare()
        }
    }
    
    @objc func settingNotification() {
        if let moreView = self.moreAreaView {
            moreView.removeFromSuperview()
            self.moreAreaView = nil
            self.appbarActionDelegate?.actionNotificationSetting()
        }
    }
    
    @objc func settingTranslate() {
        if let moreView = self.moreAreaView {
            moreView.removeFromSuperview()
            self.moreAreaView = nil
            self.appbarActionDelegate?.actionTranslateSetting()
        }
    }
    
    @objc func settingProfile() {
        if let moreView = self.moreAreaView {
            moreView.removeFromSuperview()
            self.moreAreaView = nil
            self.appbarActionDelegate?.actionProfileSetting()
        }
    }
    
    func close() {
        self.moreAreaView?.removeFromSuperview()
    }
}

extension AppbarView: ChatUserCountDelegate {
    func updateCount(count: Int) {
        self.lbHeaderUserCount?.text = count.makeDecimal()
    }
}
