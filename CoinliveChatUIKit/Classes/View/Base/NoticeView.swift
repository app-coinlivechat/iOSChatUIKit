//
//  NoticeView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/29.
//

import UIKit

class NoticeView: UIView {
    weak var noticeActionDelegate: NoticeActionDelegate?
    private weak var tvNotice: UITextView?
    private weak var btnNoticeFold: UIButton?
    private weak var vBackground: UIView?
    private weak var btnTextFold: UIButton?
    private weak var btnTextAll: UIButton?
    private let btnNoticeSize: CGFloat = 38.0
    private let minHeight: CGFloat = 44.0
    private let maxHeight: CGFloat = 190.0
    private let textBtnHeight: CGFloat = 40.0
    
    private var btnNoticeLeadingConstraint: NSLayoutConstraint?
    private var btnNoticeTrailingConstraint: NSLayoutConstraint?
    private var backgroundHeightConstraint: NSLayoutConstraint?
    private var btnTextShowAllHeightConstraint: NSLayoutConstraint?
    private var btnTextFoldHeightConstraint: NSLayoutConstraint?
    private var isExpand: Bool = false
    private var noticeMessage: String = ""
    
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
        let vBackground = UIView()
        vBackground.translatesAutoresizingMaskIntoConstraints = false
        vBackground.backgroundColor = .backgroundNotice
        vBackground.layer.borderWidth = 1.0
        vBackground.layer.borderColor = UIColor.borderNotice.cgColor
        vBackground.isHidden = true
        self.addSubview(vBackground)
        
        let btnNoticeFold = UIButton(type: .custom)
        btnNoticeFold.setImage(UIImage.notice, for: .normal)
        btnNoticeFold.backgroundColor = .backgroundNotice
        btnNoticeFold.layer.cornerRadius = self.btnNoticeSize / 2.0
        btnNoticeFold.translatesAutoresizingMaskIntoConstraints = false
        btnNoticeFold.isUserInteractionEnabled = true
        vBackground.addSubview(btnNoticeFold)
        self.btnNoticeFold = btnNoticeFold
        
        let btnTextFold = UIButton(type: .custom)
        btnTextFold.setTitle("notification_board_fold".localized(), for: .normal)
        btnTextFold.backgroundColor = .backgroundNotice
        btnTextFold.layer.borderColor = UIColor.borderNotice.cgColor
        btnTextFold.layer.borderWidth = 1.0
        btnTextFold.roundCorners(cornerRadius: 6.0, maskedCorners: .layerMinXMaxYCorner)
        btnTextFold.translatesAutoresizingMaskIntoConstraints = false
        btnTextFold.isUserInteractionEnabled = true
        btnTextFold.titleLabel?.textAlignment = .center
        btnTextFold.setTitleColor(.btnNotice, for: .normal)
        btnTextFold.setTitleColor(.btnNotice.withAlphaComponent(0.8), for: .highlighted)
        btnTextFold.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        vBackground.addSubview(btnTextFold)
        self.btnTextFold = btnTextFold
        
        let btnTextAll = UIButton(type: .custom)
        btnTextAll.setTitle("notification_board_show_all".localized(), for: .normal)
        btnTextAll.backgroundColor = .backgroundNotice
        btnTextAll.layer.borderColor = UIColor.borderNotice.cgColor
        btnTextAll.layer.borderWidth = 1.0
        btnTextFold.roundCorners(cornerRadius: 6.0, maskedCorners: .layerMaxXMaxYCorner)
        btnTextAll.translatesAutoresizingMaskIntoConstraints = false
        btnTextAll.isUserInteractionEnabled = true
        btnTextAll.titleLabel?.textAlignment = .center
        btnTextAll.setTitleColor(.btnNotice, for: .normal)
        btnTextAll.setTitleColor(.btnNotice.withAlphaComponent(0.8), for: .highlighted)
        btnTextAll.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        vBackground.addSubview(btnTextAll)
        self.btnTextAll = btnTextAll
        
        let tvNotice = UITextView()
        tvNotice.translatesAutoresizingMaskIntoConstraints = false
        tvNotice.textColor = .label
        tvNotice.textAlignment = .left
        tvNotice.isSelectable = false
        tvNotice.backgroundColor = .backgroundNotice
        tvNotice.textContainerInset = .init(top: 12, left: 8, bottom: 12, right: 48)
        tvNotice.isEditable = false
        tvNotice.isScrollEnabled = false
        tvNotice.font = UIFont.systemFont(ofSize: 14.0)
        tvNotice.textContainer.lineBreakMode = .byTruncatingTail
        tvNotice.text = self.noticeMessage
        vBackground.addSubview(tvNotice)
        self.tvNotice = tvNotice
        self.vBackground = vBackground
        
        NSLayoutConstraint.activate([
            vBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vBackground.topAnchor.constraint(equalTo: self.topAnchor),
            vBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            btnNoticeFold.topAnchor.constraint(equalTo: vBackground.topAnchor),
            btnNoticeFold.widthAnchor.constraint(equalToConstant: self.btnNoticeSize),
            btnNoticeFold.heightAnchor.constraint(equalToConstant: self.btnNoticeSize),
            
            btnTextAll.leadingAnchor.constraint(equalTo: vBackground.leadingAnchor),
            btnTextAll.bottomAnchor.constraint(equalTo: vBackground.bottomAnchor),
            btnTextAll.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: 1),
            
            btnTextFold.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            btnTextFold.bottomAnchor.constraint(equalTo: vBackground.bottomAnchor),
            btnTextFold.trailingAnchor.constraint(equalTo: vBackground.trailingAnchor),
            
            tvNotice.leadingAnchor.constraint(equalTo: btnNoticeFold.trailingAnchor),
            tvNotice.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tvNotice.topAnchor.constraint(equalTo: self.topAnchor),
            tvNotice.bottomAnchor.constraint(equalTo: btnTextAll.topAnchor)
        ])
        
        self.btnNoticeLeadingConstraint = btnNoticeFold.leadingAnchor.constraint(equalTo: vBackground.leadingAnchor)
        self.btnNoticeTrailingConstraint = btnNoticeFold.trailingAnchor.constraint(equalTo: vBackground.trailingAnchor)
        self.backgroundHeightConstraint = vBackground.heightAnchor.constraint(equalToConstant: 0)
        
        self.btnTextFoldHeightConstraint = btnTextFold.heightAnchor.constraint(equalToConstant: 0)
        self.btnTextShowAllHeightConstraint = btnTextAll.heightAnchor.constraint(equalToConstant: 0)
        
        self.btnNoticeLeadingConstraint?.isActive = false
        self.btnNoticeTrailingConstraint?.isActive = false
        self.backgroundHeightConstraint?.isActive = true
        self.btnTextFoldHeightConstraint?.isActive = true
        self.btnTextShowAllHeightConstraint?.isActive = true
        
        btnNoticeFold.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickFold)))
        btnTextFold.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickFoldText)))
        btnTextAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickShowAllText)))
        tvNotice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickNoticeBody)))
    }
    
    internal func showNotice(notice: String) {
        self.noticeMessage = notice
        self.tvNotice?.text = notice
        if !self.isExpand {
            self.collapse()
        }
    }
    
    func collapse() {
        self.isExpand = false
        self.tvNotice?.textContainer.maximumNumberOfLines = 1
        self.tvNotice?.adjustsFontForContentSizeCategory = false
        self.tvNotice?.sizeToFit()
        self.btnTextAll?.isHidden = true
        self.btnTextFold?.isHidden = true
        self.tvNotice?.isHidden = false
        self.backgroundHeightConstraint?.constant = self.minHeight
        self.btnNoticeLeadingConstraint?.isActive = true
        self.btnNoticeTrailingConstraint?.isActive = false
        self.vBackground?.layer.cornerRadius = 6.0
        self.vBackground?.clipsToBounds = true
        self.vBackground?.isHidden = false
        self.btnTextShowAllHeightConstraint?.constant = 0
        self.btnTextFoldHeightConstraint?.constant = 0
        
        self.noticeActionDelegate?.collapseNotice()
    }
    
    func expand() {
        self.isExpand = true
        self.btnTextShowAllHeightConstraint?.constant = self.textBtnHeight
        self.btnTextFoldHeightConstraint?.constant = self.textBtnHeight
        
        self.tvNotice?.textContainer.maximumNumberOfLines = 6
        self.tvNotice?.adjustsFontForContentSizeCategory = false
        self.tvNotice?.sizeToFit()
        
        let contentSize = self.tvNotice?.contentSize.height ?? 0
        let height = self.minHeight + self.textBtnHeight + (contentSize - self.minHeight)
        
        self.backgroundHeightConstraint?.constant = height
        self.noticeActionDelegate?.expandNotice(height: height)
        self.btnTextAll?.isHidden = false
        self.btnTextFold?.isHidden = false
    }
    
    func fold() {
        self.isExpand = false
        self.btnTextAll?.isHidden = true
        self.btnTextFold?.isHidden = true
        self.tvNotice?.isHidden = true
        self.backgroundHeightConstraint?.constant = self.btnNoticeSize
        self.btnNoticeLeadingConstraint?.isActive = false
        self.btnNoticeTrailingConstraint?.isActive = true
        self.vBackground?.layer.cornerRadius = self.btnNoticeSize / 2.0
        self.vBackground?.clipsToBounds = true
        self.vBackground?.isHidden = false
        self.btnTextShowAllHeightConstraint?.constant = 0
        self.btnTextFoldHeightConstraint?.constant = 0
        self.noticeActionDelegate?.foldNotice()
    }
    
    @objc func clickFold() {
        self.collapse()
    }
    
    @objc func clickNoticeBody() {
        if self.isExpand {
            self.collapse()
        } else {
            self.expand()
        }
    }
    
    @objc func clickShowAllText() {
        self.noticeActionDelegate?.clickShowAll(message: self.noticeMessage)
    }
    
    @objc func clickFoldText() {
        self.fold()
    }
}
