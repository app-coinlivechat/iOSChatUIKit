//
//  TranslatorViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import UIKit
import CoinliveChatSDK

public class TranslatorViewController: UIViewController {
    private weak var backBarView: BackBarView?
    private let baseToolbarSize: CGFloat = 60.0
    private let rightButtonSize: CGFloat = 24.0
    private let lineHeight: CGFloat = 64.0
    private var scAll: UISwitch!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSystemUi()
        self.initializeUi()
    }
    
    private func initializeUi() {
        let backBarView = BackBarView()
        backBarView.loadData(title: "translation_title".localized())
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
        
        let vTranslatorLine = createSwitchLineView(title: "translation_all".localized(), selector: #selector(onChangeTranslate(_:)))
        
        self.view.addSubview(vTranslatorLine.0)
        
        self.scAll = vTranslatorLine.1
        
        let divider2 = UIView()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.backgroundColor = .settingDivider
        self.view.addSubview(divider2)
        
        let resultLanguageLine = self.createRightArrowLine(title: "translation_result_language".localized(), rightTitle: "translation_result_language_ko".localized())
        resultLanguageLine.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapTranslate)))
        self.view.addSubview(resultLanguageLine)
        
        NSLayoutConstraint.activate([
            vTranslatorLine.0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vTranslatorLine.0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vTranslatorLine.0.topAnchor.constraint(equalTo: backBarView.bottomAnchor, constant: 1),
            vTranslatorLine.0.heightAnchor.constraint(equalToConstant: self.lineHeight),
            
            divider2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 12.0),
            divider2.topAnchor.constraint(equalTo: vTranslatorLine.0.bottomAnchor),
            
            resultLanguageLine.topAnchor.constraint(equalTo: divider2.bottomAnchor),
            resultLanguageLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            resultLanguageLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            resultLanguageLine.heightAnchor.constraint(equalToConstant: self.lineHeight)
        ])
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
    
    private func createRightArrowLine(title: String, rightTitle: String) -> UIView {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .background
        
        let lbLeftTitle = UILabel()
        lbLeftTitle.translatesAutoresizingMaskIntoConstraints = false
        lbLeftTitle.textColor = .label
        lbLeftTitle.font = UIFont.systemFont(ofSize: 16.0)
        lbLeftTitle.text = title
        lineView.addSubview(lbLeftTitle)
        
        let lbRightTitle = UILabel()
        lbRightTitle.translatesAutoresizingMaskIntoConstraints = false
        lbRightTitle.textColor = .label
        lbRightTitle.font = UIFont.systemFont(ofSize: 16.0)
        lbRightTitle.text = rightTitle
        lineView.addSubview(lbRightTitle)
        
        let btnArrow = UIImageView()
        btnArrow.translatesAutoresizingMaskIntoConstraints = false
        btnArrow.image = .rightArrow
        lineView.addSubview(btnArrow)
        
        NSLayoutConstraint.activate([
            lbLeftTitle.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16.0),
            lbLeftTitle.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            
            btnArrow.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16.0),
            btnArrow.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            btnArrow.heightAnchor.constraint(equalToConstant: self.rightButtonSize),
            btnArrow.widthAnchor.constraint(equalToConstant: self.rightButtonSize),
            
            lbRightTitle.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            lbRightTitle.trailingAnchor.constraint(equalTo: btnArrow.leadingAnchor, constant: -6.0),
        ])
        
        return lineView
    }
    
    @objc func onChangeTranslate(_ sender: UISwitch!) {
        
    }
    
    @objc func onTapTranslate() {
        self.showSelectLanguageBottomSheet()
//        self.showDownloadResourceAlert()
    }
    
    private func showSelectLanguageBottomSheet() {
        
        let translatorBottomSheetViewController = TranslatorBottomSheetViewController()
        self.present(translatorBottomSheetViewController, animated: true)
    }
    
    private func showDownloadResourceAlert() {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.loadData(descriptionText: "translation_download_comment".localized(), confirmText: "common_confirm".localized(), cancelText: "common_cancel".localized(), confirmButtonColor: .primary, cancelButtonColor: .backgroundPopupCancel)
        self.present(alert, animated: false)
    }
}

extension TranslatorViewController: BackBarActionDelegate {
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionTranslate() {
        
    }
}
