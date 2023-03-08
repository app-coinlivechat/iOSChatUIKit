//
//  MessageAlarmSettingViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/24.
//

import UIKit
import CoinliveChatSDK

public class NotificationSettingViewController: UIViewController {
    internal weak var notificationSettingDelegate: NotificationSettingDelegate?
    private weak var backBarView: BackBarView?
    private let baseToolbarSize: CGFloat = 60.0
    private let lineHeight: CGFloat = 64.0
    private var scAll: UISwitch!
    private var notificationSettingsClone: Dictionary<String, Bool> = [:]
    private var notificationSettings: Dictionary<String, Bool> = [:]
    private var scGroups: Array<UISwitch> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSystemUi()
        self.initializeUi()
    }
    
    private func initializeUi() {
        let backBarView = BackBarView()
        backBarView.loadData(title: "notification_setting_title".localized())
        backBarView.backBarActionDelegate = self
        let divider = CALayer()
        divider.backgroundColor = UIColor.headerDivider.cgColor
        divider.frame = CGRect(origin: CGPointMake(0, (self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize) - 1), size: CGSize(width: self.view.frame.size.width, height: 1))
        backBarView.layer.addSublayer(divider)
        
        self.view.addSubview(backBarView)
        
        self.backBarView = backBarView
        
        backBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backBarView.heightAnchor.constraint(equalToConstant: self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize).isActive = true
        
        
        let vAllLine = createSwitchLineView(title: "notification_all_label".localized(), selector: #selector(onChanceAll(_:)))
        let vBuySellLine = createSwitchLineView(title: "notification_liquidation".localized(), selector: #selector(onChangeBuySell(_:)))
        let vTwitterLine = createSwitchLineView(title: "notification_twitter".localized(), selector: #selector(onChangeTwitter(_:)))
        let vMediumLine = createSwitchLineView(title: "notification_medium".localized(), selector: #selector(onChangeMedium(_:)))
        
        self.view.addSubview(vAllLine.0)
        self.view.addSubview(vBuySellLine.0)
        self.view.addSubview(vTwitterLine.0)
        self.view.addSubview(vMediumLine.0)
        
        self.scAll = vAllLine.1
        self.scGroups.append(vBuySellLine.1)
        self.scGroups.append(vTwitterLine.1)
        self.scGroups.append(vMediumLine.1)
        
        let isChatBuySell = notificationSettingsClone["CHAT_LIQUIDATION"] ?? false
        let isChatTwitter = notificationSettingsClone["CHAT_TWITTER"] ?? false
        let isChatMedium = notificationSettingsClone["CHAT_MEDIUM"] ?? false
        let isAll = isChatMedium && isChatTwitter && isChatBuySell
        
        self.scAll.isOn = isAll
        vBuySellLine.1.isOn = isChatBuySell
        vTwitterLine.1.isOn = isChatTwitter
        vMediumLine.1.isOn = isChatMedium
        
        let divider2 = UIView()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.backgroundColor = .settingDivider
        self.view.addSubview(divider2)
        
        NSLayoutConstraint.activate([
            vAllLine.0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vAllLine.0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vAllLine.0.topAnchor.constraint(equalTo: backBarView.bottomAnchor, constant: 1),
            vAllLine.0.heightAnchor.constraint(equalToConstant: self.lineHeight),
            
            divider2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 12.0),
            divider2.topAnchor.constraint(equalTo: vAllLine.0.bottomAnchor),
            
            vBuySellLine.0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vBuySellLine.0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vBuySellLine.0.topAnchor.constraint(equalTo: divider2.bottomAnchor),
            vBuySellLine.0.heightAnchor.constraint(equalToConstant: self.lineHeight),
            
            vTwitterLine.0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vTwitterLine.0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vTwitterLine.0.topAnchor.constraint(equalTo: vBuySellLine.0.bottomAnchor),
            vTwitterLine.0.heightAnchor.constraint(equalToConstant: self.lineHeight),
            
            vMediumLine.0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vMediumLine.0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vMediumLine.0.topAnchor.constraint(equalTo: vTwitterLine.0.bottomAnchor),
            vMediumLine.0.heightAnchor.constraint(equalToConstant: self.lineHeight),
        ])
    }
    
    internal func loadData(notificationSettings: Dictionary<String, Bool>) {
        self.notificationSettings = notificationSettings
        self.notificationSettingsClone = notificationSettings
    }
    
    private func initializeSystemUi() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .background
    }
    
    private func createSwitchLineView(title: String, selector: Selector) -> (UIView, UISwitch) {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .background
        
        let lbLeftTitle = UILabel()
        lbLeftTitle.translatesAutoresizingMaskIntoConstraints = false
        lbLeftTitle.textColor = .label
        lbLeftTitle.font = UIFont.systemFont(ofSize: 16.0)
        lbLeftTitle.text = title
        lineView.addSubview(lbLeftTitle)
        
        let scBtn = UISwitch()
        scBtn.translatesAutoresizingMaskIntoConstraints = false
        scBtn.onTintColor = .primary
        scBtn.addTarget(self, action: selector, for: .valueChanged)
        lineView.addSubview(scBtn)
        
        NSLayoutConstraint.activate([
            lbLeftTitle.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16.0),
            lbLeftTitle.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            
            scBtn.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16.0),
            scBtn.centerYAnchor.constraint(equalTo: lineView.centerYAnchor)
        ])
        
        return (lineView, scBtn)
    }
    
    @objc func onChanceAll(_ sender: UISwitch!) {
        self.notificationSettings["CHAT_LIQUIDATION"] = sender.isOn
        self.notificationSettings["CHAT_TWITTER"] = sender.isOn
        self.notificationSettings["CHAT_MEDIUM"] = sender.isOn
        self.checkAll(isCheck: sender.isOn)
    }
    
    @objc func onChangeBuySell(_ sender: UISwitch!) {
        self.notificationSettings["CHAT_LIQUIDATION"] = sender.isOn
        self.checkOtherSwitchViews()
    }
    
    @objc func onChangeTwitter(_ sender: UISwitch!) {
        self.notificationSettings["CHAT_TWITTER"] = sender.isOn
        self.checkOtherSwitchViews()
    }
    
    @objc func onChangeMedium(_ sender: UISwitch!) {
        self.notificationSettings["CHAT_MEDIUM"] = sender.isOn
        self.checkOtherSwitchViews()
    }
    
    private func checkOtherSwitchViews() {
        let isOnAll = self.scGroups.contains(where: { $0.isOn == false })
        self.scAll.setOn(!isOnAll, animated: true)
        
    }
    
    private func checkAll(isCheck: Bool) {
        self.scGroups.forEach { view in
            view.setOn(isCheck, animated: true)
        }
    }
}

extension NotificationSettingViewController: BackBarActionDelegate {
    func actionBack() {
        var changedNotificationMap: Dictionary<String, Bool> = [:]
        self.notificationSettings.forEach { (k1, i1) in
            if i1 != self.notificationSettingsClone[k1] {
                changedNotificationMap[k1] = i1
            }
        }
        
        if changedNotificationMap.count > 0 {
            self.notificationSettingDelegate?.reloadSettings(settings: changedNotificationMap)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionTranslate() {
        
    }
}
