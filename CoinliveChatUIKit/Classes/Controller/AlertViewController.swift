//
//  AlertViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/25.
//

import UIKit

class AlertViewController: UIViewController {
    public weak var alertActionDelegate: AlertActionDelegate?
    
    private var descriptionText: String = ""
    private var confirmText: String = ""
    private var cancelText: String = ""
    private var confirmButtonColor: UIColor = .gray
    private var cancelButtonColor: UIColor = .gray
    
    private let btnWidth = 135.0
    private let btnHeight = 48.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    internal func loadData(descriptionText: String, confirmText: String, cancelText: String, confirmButtonColor: UIColor, cancelButtonColor: UIColor) {
        self.descriptionText = descriptionText
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.confirmButtonColor = confirmButtonColor
        self.cancelButtonColor = cancelButtonColor
    }
    
    private func initView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        let alertView = UIView()
        alertView.layer.cornerRadius = 16
        alertView.backgroundColor = .backgroundPopup
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let alertDescriptionLabel = self.createLabel()
        alertDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        alertDescriptionLabel.textColor = .label
        alertDescriptionLabel.text = self.descriptionText
        alertDescriptionLabel.numberOfLines = 0
        alertDescriptionLabel.textAlignment = .center
        
        alertView.addSubview(alertDescriptionLabel)
        
        let confirmButton = self.createTextButton(title: self.confirmText, backgroundColor: self.confirmButtonColor, titleColor: .white, fontSize: 16)
        confirmButton.layer.cornerRadius = 12
        confirmButton.addTarget(self, action: #selector(self.confirmAlert), for: .touchUpInside)
        
        let cancelButton = self.createTextButton(title: self.cancelText, backgroundColor: self.cancelButtonColor, titleColor: .labelPopupCancel, fontSize: 16)
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(self.closeAlert), for: .touchUpInside)
        
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancelButton)
        
        self.view.addSubview(alertView)
        
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: 311).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 174).isActive = true
        
        alertDescriptionLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24.0).isActive = true
        alertDescriptionLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16.0).isActive = true
        alertDescriptionLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16.0).isActive = true
        
        cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16.0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: self.btnWidth).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: self.btnHeight).isActive = true
        
        confirmButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancelButton.trailingAnchor, constant: 8.0).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20.0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16.0).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: self.btnWidth).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: self.btnHeight).isActive = true
    }
    
    private func createTextButton(title: String, backgroundColor: UIColor, titleColor: UIColor, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        button.layer.cornerRadius = 5.0
        return button
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc func confirmAlert() {
        self.dismiss(animated: false) {
            self.alertActionDelegate?.confirm()
        }
    }
    
    @objc func closeAlert() {
        self.dismiss(animated: false) {
            self.alertActionDelegate?.cancel()
        }
    }
}
