//
//  BackBarView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/24.
//

import UIKit

class BackBarView: UIView {
    internal weak var backBarActionDelegate: BackBarActionDelegate?
    private let backButtonSize: CGFloat = 28.0
    
    private weak var btnBack: UIButton?
    private weak var lbTitle: UILabel?
    private weak var btnTranslate: UIButton?
    
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
        
        let lbTitle = UILabel()
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.font = UIFont.systemFont(ofSize: 16.0)
        lbTitle.textColor = .label
        self.addSubview(lbTitle)
        self.lbTitle = lbTitle
        
        let btnBack = UIButton(type: .custom)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.setImage(.back, for: .normal)
        btnBack.addTarget(self, action: #selector(self.actionBack), for: .touchUpInside)
        self.addSubview(btnBack)
        self.btnBack = btnBack
        
        let btnTranslate = UIButton(type: .custom)
        btnTranslate.translatesAutoresizingMaskIntoConstraints = false
        btnTranslate.setTitle("translation_all".localized(), for: .normal)
        btnTranslate.setTitleColor(.primary, for: .normal)
        btnTranslate.setTitleColor(.primary.withAlphaComponent(0.8), for: .highlighted)
        btnTranslate.addTarget(self, action: #selector(self.actionTranslate), for: .touchUpInside)
        btnTranslate.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btnTranslate.isHidden = true
        self.addSubview(btnTranslate)
        self.btnTranslate = btnTranslate
        
        NSLayoutConstraint.activate([
            btnBack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0),
            btnBack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            btnBack.widthAnchor.constraint(equalToConstant: self.backButtonSize),
            btnBack.heightAnchor.constraint(equalToConstant: self.backButtonSize),
            
            lbTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lbTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            btnTranslate.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            btnTranslate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0)
        ])
    }
    
    public func addTranslateButton() {
        self.btnTranslate?.isHidden = false
    }
    
    internal func loadData(title: String) {
        self.lbTitle?.text = title
    }
    
    @objc func actionBack() {
        self.backBarActionDelegate?.actionBack()
    }
    
    @objc func actionTranslate() {
        self.backBarActionDelegate?.actionTranslate()
    }
}
