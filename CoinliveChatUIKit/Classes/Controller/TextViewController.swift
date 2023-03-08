//
//  TextViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import UIKit


class TextViewController: UIViewController {
    private weak var backBarView: BackBarView?
    private let baseToolbarSize: CGFloat = 60.0
    private weak var tvMessage: UITextView?
    var message: String? = nil
    var isMine: Bool = false
    var isTranslate: Bool = false
    var titleText: String = "notification_board_show_all".localized()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeUi()
    }
    
    private func initializeUi() {
        self.view.backgroundColor = .background
        let backBarView = BackBarView()
        
        backBarView.loadData(title: self.titleText)
        backBarView.backBarActionDelegate = self
        
        self.view.addSubview(backBarView)
        self.backBarView = backBarView
        
        if !self.isMine && !self.isTranslate {
            backBarView.addTranslateButton()
        }
        
        backBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backBarView.heightAnchor.constraint(equalToConstant: self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize).isActive = true
        
        let divider = CALayer()
        divider.backgroundColor = UIColor.headerDivider.cgColor
        divider.frame = CGRect(origin: CGPointMake(0, (self.navigationController?.toolbar.bounds.height ?? self.baseToolbarSize) - 1), size: CGSize(width: self.view.frame.size.width, height: 1))
        backBarView.layer.addSublayer(divider)
        
        let tvMessage = UITextView()
        tvMessage.translatesAutoresizingMaskIntoConstraints = false
        tvMessage.isEditable = false
        tvMessage.isScrollEnabled = true
        tvMessage.isUserInteractionEnabled = true
        tvMessage.textColor = .label
        tvMessage.font = UIFont.systemFont(ofSize: 16)
        tvMessage.textContainerInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        tvMessage.backgroundColor = .background
        tvMessage.dataDetectorTypes = .link
        
        if let actualRecognizers = tvMessage.gestureRecognizers {
            for recognizer in actualRecognizers {
                if recognizer.isKind(of: UILongPressGestureRecognizer.self) {
                    recognizer.isEnabled = false
                }
            }
        }
        
        if let message = self.message {
            tvMessage.text = message
        }
        self.view.addSubview(tvMessage)
        self.tvMessage = tvMessage
        
        tvMessage.topAnchor.constraint(equalTo: backBarView.bottomAnchor).isActive = true
        tvMessage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tvMessage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tvMessage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension TextViewController: BackBarActionDelegate {
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionTranslate() {
        // action
    }
}
