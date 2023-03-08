//
//  MessageDateView.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/16.
//

import UIKit

class MessageDateView: UIView {
    private weak var lbDate: UILabel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUi()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUi()
    }
    
    private func initializeUi() {
        self.backgroundColor = .background
        let lbDate = UILabel()
        lbDate.textColor = .label
        lbDate.font = UIFont.systemFont(ofSize: 14.0)
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbDate)
        self.lbDate = lbDate
        
        NSLayoutConstraint.activate([
            lbDate.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lbDate.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    public func setUpData(date: String) {
        self.lbDate?.text = "\(date.suffix(5))"
        self.lbDate?.sizeToFit()
        layoutIfNeeded()
    }
}
