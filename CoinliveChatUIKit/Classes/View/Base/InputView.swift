//
//  InputView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/15.
//

import UIKit

class InputView: UIView {
    private weak var inputViewDelegate: InputViewDelegate?
    private weak var lbPlaceHolder: UILabel?
    
//    private var btnPlus: UIButton!
    private weak var tvInsertChat: UITextView?
    private weak var btnSend: UIButton?
    
    private weak var tvInsertChatHeightConstraint: NSLayoutConstraint? = nil
    private var tvHeightInsertChat: CGFloat = 36.0
    var isAnonymousUser: Bool = false
    private var limitTimer: Timer?
    
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
    
    deinit {
        self.tvInsertChatHeightConstraint = nil
        self.limitTimer?.invalidate()
    }
    
    func close() {
        self.limitTimer?.invalidate()
        self.limitTimer = nil
    }
    
    private func initializeUi() {
        backgroundColor = .background
        translatesAutoresizingMaskIntoConstraints = false
//        self.btnPlus = UIButton(type: .custom)
//        self.btnPlus.translatesAutoresizingMaskIntoConstraints = false
//        self.btnPlus.setImage(.plus, for: .normal)
//        self.btnPlus.addTarget(self, action: #selector(actionPlus), for: .touchUpInside)
        
        let btnSend = UIButton(type: .custom)
        
        btnSend.translatesAutoresizingMaskIntoConstraints = false
        btnSend.setImage(.send, for: .normal)
        btnSend.addTarget(self, action: #selector(actionSend), for: .touchUpInside)
        
        self.addSubview(btnSend)
        self.btnSend = btnSend
        
        let tvInsertChat = UITextView()
        tvInsertChat.isEditable = true
        tvInsertChat.isScrollEnabled = true
        tvInsertChat.translatesAutoresizingMaskIntoConstraints = false
        tvInsertChat.textColor = .boxMessageText
        tvInsertChat.backgroundColor = .boxMessage
        tvInsertChat.layer.cornerRadius = self.tvHeightInsertChat / 2
        tvInsertChat.font = UIFont.systemFont(ofSize: 14)
        tvInsertChat.delegate = self
        tvInsertChat.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.addSubview(tvInsertChat)
        self.tvInsertChat = tvInsertChat
        
        let lbPlaceHolder = UILabel()
        lbPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        lbPlaceHolder.text = "input_chat_placeholder".localized()
        lbPlaceHolder.textColor = .boxMessageInputPlaceholder
        lbPlaceHolder.font = UIFont.systemFont(ofSize: 14)
        lbPlaceHolder.isHidden = !tvInsertChat.text.isEmpty
        
//        self.addSubview(self.btnPlus)
        self.addSubview(lbPlaceHolder)
        self.lbPlaceHolder = lbPlaceHolder
        
//        self.btnPlus.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.btnPlus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
//        self.btnPlus.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
//        self.btnPlus.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        tvInsertChat.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
        tvInsertChat.trailingAnchor.constraint(equalTo: btnSend.leadingAnchor, constant: -12.0).isActive = true
        tvInsertChat.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        lbPlaceHolder.leadingAnchor.constraint(equalTo: tvInsertChat.leadingAnchor, constant: 20.0).isActive = true
        lbPlaceHolder.trailingAnchor.constraint(equalTo: btnSend.leadingAnchor, constant: -12.0).isActive = true
        lbPlaceHolder.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lbPlaceHolder.heightAnchor.constraint(equalToConstant: tvHeightInsertChat).isActive = true
        
        self.tvInsertChatHeightConstraint = tvInsertChat.heightAnchor.constraint(equalToConstant: tvHeightInsertChat)
        self.tvInsertChatHeightConstraint?.isActive = true
        
        btnSend.leadingAnchor.constraint(equalTo: tvInsertChat.trailingAnchor, constant: 12.0).isActive = true
        btnSend.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
        btnSend.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        btnSend.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        btnSend.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
    }
    internal func setUpData(inputViewDelegate: InputViewDelegate, isAnonymousUser: Bool) {
        self.inputViewDelegate = inputViewDelegate
        self.isAnonymousUser = isAnonymousUser
        if self.isAnonymousUser {
            self.lbPlaceHolder?.text = "input_chat_placeholder_unknown_user".localized()
            self.tvInsertChat?.isUserInteractionEnabled = false
            self.tvInsertChat?.backgroundColor = .backgroundAnonymousInput
            self.lbPlaceHolder?.textColor = .labelAnonymous
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.clickAnonymousUserClick))
            self.addGestureRecognizer(gesture)
        }
    }
    
    @objc func clickAnonymousUserClick() {
        CoinliveUIKit.shared.inputViewUnknownUserProtocol?.click()
    }
                                                     
    @objc func actionSend() {
        if self.isAnonymousUser {
            return
        }
        guard let message = self.tvInsertChat?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let messageCount = message.count
        if messageCount < 1 {
            return
        }
        
        self.tvInsertChat?.text = ""
        self.tvHeightInsertChat = (self.tvInsertChat?.contentSize.height ?? 0) + 3.0
        self.tvInsertChatHeightConstraint?.constant = self.tvHeightInsertChat
        self.inputViewDelegate?.changeInputViewHeight(height: self.tvInsertChat?.contentSize.height ?? 0)
        self.inputViewDelegate?.sendMessage(message: message)
    }
                                                     
    
    func blockInputText() {
        if self.isAnonymousUser {
            return
        }
        self.tvInsertChat?.text = nil
        self.lbPlaceHolder?.text = "input_chat_placeholder_ama".localized()
        self.lbPlaceHolder?.isHidden = false
        self.tvInsertChat?.isUserInteractionEnabled = false
    }
    
    func blockTimeLimit(time: Int) {
        if self.isAnonymousUser {
            return
        }
        if limitTimer != nil {
            return
        }
        self.tvInsertChat?.text = nil
        self.tvInsertChat?.isUserInteractionEnabled = false
        self.tvInsertChat?.backgroundColor = .backgroundAnonymousInput
        self.lbPlaceHolder?.isHidden = false
        self.lbPlaceHolder?.textColor = .labelAnonymous
        
        var diffTime = 15 - time
        DispatchQueue.main.async {
            self.lbPlaceHolder?.text = (diffTime / 10) > 0 ? "00:\(diffTime)" : "00:0\(diffTime)"
        }
        limitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            diffTime -= Int(timer.timeInterval)
            DispatchQueue.main.async {
                self?.lbPlaceHolder?.text = (diffTime / 10) > 0 ? "00:\(diffTime)" : "00:0\(diffTime)"
            }
            if diffTime < 0 {
                timer.invalidate()
                self?.limitTimer = nil
                DispatchQueue.main.async {
                    self?.lbPlaceHolder?.textColor = .boxMessageInputPlaceholder
                    self?.changeStatus(isLock: false)
                }
            }
        })
    }
    
    func changeStatus(isLock: Bool) {
        if self.isAnonymousUser {
            return
        }
        
        if limitTimer != nil {
            return
        }
        
        self.tvInsertChat?.textColor = .boxMessageText
        self.tvInsertChat?.backgroundColor = .boxMessage
        self.tvInsertChat?.text = nil
        self.lbPlaceHolder?.text = isLock ? "input_chat_placeholder_block".localized() : "input_chat_placeholder".localized()
        self.lbPlaceHolder?.isHidden = false
        self.tvInsertChat?.isUserInteractionEnabled = !isLock
    }
    
    func unBlockInpuText() {
        if self.isAnonymousUser {
            return
        }
        self.lbPlaceHolder?.text = "input_chat_placeholder".localized()
        self.tvInsertChat?.isUserInteractionEnabled = true
    }
    
    func endEditInputView() {
        self.tvInsertChat?.resignFirstResponder()
        
        guard let textView = self.tvInsertChat else { return }
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.tvInsertChat?.text = ""
            self.lbPlaceHolder?.isHidden = false
            self.tvHeightInsertChat = (self.tvInsertChat?.contentSize.height ?? 0) + 3.0
            self.tvInsertChatHeightConstraint?.constant = self.tvHeightInsertChat
            self.inputViewDelegate?.changeInputViewHeight(height: (self.tvInsertChat?.contentSize.height ?? 0))
        }
    }
}

extension InputView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .boxMessageInputPlaceholder {
            textView.text = nil
            textView.textColor = .boxMessageText
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.lbPlaceHolder?.isHidden = !textView.text.isEmpty
        
        if textView.contentSize.height < 117 {
            if self.tvHeightInsertChat == textView.contentSize.height + 3.0 {
                return
            }
            self.tvHeightInsertChat = textView.contentSize.height + 3.0
            self.tvInsertChatHeightConstraint?.constant = self.tvHeightInsertChat
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
            self.inputViewDelegate?.changeInputViewHeight(height: textView.contentSize.height)
        } else {
            if self.tvHeightInsertChat != 120 {
                self.tvHeightInsertChat = 117 + 3.0
                self.tvInsertChatHeightConstraint?.constant = 120
                UIView.animate(withDuration: 0.1, animations: {
                    self.layoutIfNeeded()
                })
                self.inputViewDelegate?.changeInputViewHeight(height: 117)
            }
        }
    }
    
    private func checkAndResizeTextField(_ textView: UITextView) {
        self.lbPlaceHolder?.isHidden = !textView.text.isEmpty
        
        if textView.contentSize.height < 117 {
            if self.tvHeightInsertChat == textView.contentSize.height + 3.0 {
                return
            }
            self.tvHeightInsertChat = textView.contentSize.height + 3.0
            self.tvInsertChatHeightConstraint?.constant = self.tvHeightInsertChat
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
            self.inputViewDelegate?.changeInputViewHeight(height: textView.contentSize.height)
        }
    }
}
