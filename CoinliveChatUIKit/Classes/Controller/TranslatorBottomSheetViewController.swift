//
//  BottomSheetViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import UIKit

enum TRANSLALTE_LANGUAGE {
    case NONE
    case KOREAN
    case ENGLISH
    case CHINESE
}

class TranslatorBottomSheetViewController: UIViewController {
    public weak var translateBottomSheetDelegate: TranslateBottomSheetDelegate?
    private let checkboxSize = 24.0
    private let lineViewHeight = 54.0
    
    private weak var cblKorean: UIView!
    private weak var cblEnglish: UIView!
    private weak var cblChinese: UIView!
    
    private var selectLanguage: TRANSLALTE_LANGUAGE = .NONE
    
    private weak var btnKorean: UIButton!
    private weak var btnEnglish: UIButton!
    private weak var btnChinese: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPopup
        
        bottomSheetTransitioningDelegate.preferredSheetTopInset = 70.0
        
        let vIndicator = UIView()
        vIndicator.translatesAutoresizingMaskIntoConstraints = false
        vIndicator.backgroundColor = .bottomsheetIndicator
        vIndicator.layer.cornerRadius = 2.0
        self.view.addSubview(vIndicator)
        
        let tpKorean = self.createCheckboxLine(title: "translation_result_language_ko".localized())
        self.cblKorean = tpKorean.0
        self.cblKorean.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectKorean)))
        self.view.addSubview(self.cblKorean)
        self.btnKorean = tpKorean.1
        
        
        let tpEnglish = self.createCheckboxLine(title: "translation_result_language_en".localized())
        self.cblEnglish = tpEnglish.0
        self.cblEnglish.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectEnglish)))
        self.view.addSubview(self.cblEnglish)
        self.btnEnglish = tpEnglish.1
        
        
        let tpChinese = self.createCheckboxLine(title: "translation_result_language_ch".localized())
        self.cblChinese = tpChinese.0
        self.cblChinese.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectChinese)))
        self.view.addSubview(self.cblChinese)
        self.btnChinese = tpChinese.1
        
        
        NSLayoutConstraint.activate([
            vIndicator.widthAnchor.constraint(equalToConstant: self.view.bounds.size.width / 6.0),
            vIndicator.heightAnchor.constraint(equalToConstant: 4.0),
            vIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            vIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0),
            
            cblKorean.topAnchor.constraint(equalTo: vIndicator.bottomAnchor, constant: 14.0),
            cblKorean.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cblKorean.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cblKorean.heightAnchor.constraint(equalToConstant: self.lineViewHeight),
            
            cblEnglish.topAnchor.constraint(equalTo: cblKorean.bottomAnchor),
            cblEnglish.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cblEnglish.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cblEnglish.heightAnchor.constraint(equalToConstant: self.lineViewHeight),
            
            cblChinese.topAnchor.constraint(equalTo: cblEnglish.bottomAnchor),
            cblChinese.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cblChinese.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cblChinese.heightAnchor.constraint(equalToConstant: self.lineViewHeight),
        ])
    }
    
    private func createCheckboxLine(title: String) -> (UIView, UIButton) {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .background
        
        let lbLeftTitle = UILabel()
        lbLeftTitle.translatesAutoresizingMaskIntoConstraints = false
        lbLeftTitle.textColor = .label
        lbLeftTitle.font = UIFont.systemFont(ofSize: 16.0)
        lbLeftTitle.text = title
        lineView.addSubview(lbLeftTitle)
        
        let btnSelect = UIButton()
        btnSelect.translatesAutoresizingMaskIntoConstraints = false
        btnSelect.setImage(.unCheck , for: .normal)
        btnSelect.setImage(.check , for: .selected)
        btnSelect.isUserInteractionEnabled = false
        lineView.addSubview(btnSelect)
        
        NSLayoutConstraint.activate([
            lbLeftTitle.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16.0),
            lbLeftTitle.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            
            btnSelect.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16.0),
            btnSelect.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            btnSelect.heightAnchor.constraint(equalToConstant: self.checkboxSize),
            btnSelect.widthAnchor.constraint(equalToConstant: self.checkboxSize)
        ])
        
        return (lineView, btnSelect)
    }
    
    @objc func selectKorean() {
        if self.selectLanguage == .KOREAN {
            self.btnKorean.isSelected = false
            self.selectLanguage = .NONE
            self.cblKorean.backgroundColor = .backgroundPopup
        } else {
            self.cblKorean.backgroundColor = .backgroundPopupSelected
            self.cblEnglish.backgroundColor = .backgroundPopup
            self.cblChinese.backgroundColor = .backgroundPopup
            self.selectLanguage = .KOREAN
            self.btnKorean.isSelected = true
            self.btnEnglish.isSelected = false
            self.btnChinese.isSelected = false
        }
    }
    
    @objc func selectEnglish() {
        if self.selectLanguage == .ENGLISH {
            self.btnEnglish.isSelected = false
            self.selectLanguage = .NONE
            self.cblEnglish.backgroundColor = .backgroundPopup
        } else {
            self.cblKorean.backgroundColor = .backgroundPopup
            self.cblEnglish.backgroundColor = .backgroundPopupSelected
            self.cblChinese.backgroundColor = .backgroundPopup
            self.selectLanguage = .ENGLISH
            self.btnKorean.isSelected = false
            self.btnEnglish.isSelected = true
            self.btnChinese.isSelected = false
        }
    }
    
    @objc func selectChinese() {
        if self.selectLanguage == .CHINESE {
            self.btnChinese.isSelected = false
            self.selectLanguage = .NONE
            self.cblChinese.backgroundColor = .backgroundPopup
        } else {
            self.cblKorean.backgroundColor = .backgroundPopup
            self.cblEnglish.backgroundColor = .backgroundPopup
            self.cblChinese.backgroundColor = .backgroundPopupSelected
            self.selectLanguage = .CHINESE
            self.btnKorean.isSelected = false
            self.btnEnglish.isSelected = false
            self.btnChinese.isSelected = true
        }
    }
    
    enum PreferredSheetSizing: CGFloat {
        case small = 0.25
    }
    
    private lazy var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(
        preferredSheetTopInset: 24.0,
        preferredSheetCornerRadius: 24.0,
        preferredSheetSizingFactor: 240.0,
        preferredSheetBackdropColor: .black
    )
    
    override var additionalSafeAreaInsets: UIEdgeInsets {
        get {
            .init(
                top: super.additionalSafeAreaInsets.top + 24.0,
                left: super.additionalSafeAreaInsets.left,
                bottom: super.additionalSafeAreaInsets.bottom,
                right: super.additionalSafeAreaInsets.right
            )
        }
        set {
            super.additionalSafeAreaInsets = newValue
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            .custom
        }
        set { }
    }
    
    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get {
            bottomSheetTransitioningDelegate
        }
        set { }
    }
}
