//
//  ReportAlertViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/02.
//

import UIKit
import CoinliveChatSDK

class ReportAlertViewController: UIViewController {
    public weak var reportAlertActionDelegate: ReportAlertActionDelegate?
    
    private var descriptionText: String = ""
    private var confirmButtonColor: UIColor = .gray
    private var cancelButtonColor: UIColor = .gray
    
    private let btnWidth = 135.0
    private let btnHeight = 48.0
    private let radioLineHeight = 45.0
    private let radioButtonSize = 20.0
    
    internal var reportTypes: [ReportType] = []
    internal var reportUserId: String?
    internal var btnMap: Dictionary<String, UIButton> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    internal func loadData(descriptionText: String, confirmButtonColor: UIColor, cancelButtonColor: UIColor) {
        self.descriptionText = descriptionText
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
        alertDescriptionLabel.font = UIFont.systemFont(ofSize: 18)
        alertDescriptionLabel.textColor = .label
        alertDescriptionLabel.text = "신고"
        alertDescriptionLabel.numberOfLines = 0
        alertDescriptionLabel.textAlignment = .left
        
        alertView.addSubview(alertDescriptionLabel)
        
        let svTypes = UIStackView()
        svTypes.translatesAutoresizingMaskIntoConstraints = false
        svTypes.axis = .vertical
        
        alertView.addSubview(svTypes)
        
        self.reportTypes.forEach { type in
            guard let id = type.reportTypeId else { return }
            svTypes.addArrangedSubview(self.createRadioLineView(title: type.type ?? "", id: id))
        }
        
        let confirmButton = self.createTextButton(title: "report_confirm".localized(), backgroundColor: .primary, titleColor: .white, fontSize: 16)
        confirmButton.layer.cornerRadius = 12
        confirmButton.addTarget(self, action: #selector(self.confirmAlert), for: .touchUpInside)
        
        let cancelButton = self.createTextButton(title: "common_cancel".localized(), backgroundColor: .backgroundPopupCancel, titleColor: .labelPopupCancel, fontSize: 16)
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(self.closeAlert), for: .touchUpInside)
        
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancelButton)
        
        self.view.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 324),
            
            alertDescriptionLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24.0),
            alertDescriptionLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24.0),
            
            svTypes.topAnchor.constraint(equalTo: alertDescriptionLabel.bottomAnchor, constant: 8.0),
            svTypes.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            svTypes.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: svTypes.bottomAnchor, constant: 11.0),
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16.0),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: self.btnWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: self.btnHeight),
            
            confirmButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancelButton.trailingAnchor, constant: 8.0),
            confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20.0),
            confirmButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16.0),
            confirmButton.widthAnchor.constraint(equalToConstant: self.btnWidth),
            confirmButton.heightAnchor.constraint(equalToConstant: self.btnHeight)
        ])
    }
    
    private func createRadioLineView(title: String, id: String) -> UIView { // 52 height
        let radioLine = UIView()
        radioLine.translatesAutoresizingMaskIntoConstraints = false
        
        let radioButton = UIButton(type: .custom)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.setImage(.radioActive, for: .highlighted)
        radioButton.setImage(.radioActive, for: .selected)
        radioButton.setImage(.radioInactive, for: .normal)
        radioButton.isUserInteractionEnabled = false
        
        radioLine.addSubview(radioButton)
        
        let radioDescription = UILabel()
        radioDescription.translatesAutoresizingMaskIntoConstraints = false
        radioDescription.textColor = .label
        radioDescription.text = title
        radioDescription.font = UIFont.systemFont(ofSize: 16.0)
        radioDescription.textAlignment = .left
        radioDescription.isUserInteractionEnabled = false
        
        radioLine.addSubview(radioDescription)
        let gesture = TypeUITapGestureRecognizer(target: self, action: #selector(self.clickRadio(_:)))
        gesture.type = id
        self.btnMap[id] = radioButton
        radioLine.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: radioLine.leadingAnchor, constant: 24.0),
            radioButton.centerYAnchor.constraint(equalTo: radioLine.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: self.radioButtonSize),
            radioButton.heightAnchor.constraint(equalToConstant: self.radioButtonSize),
            
            radioDescription.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 8.0),
            radioDescription.centerYAnchor.constraint(equalTo: radioLine.centerYAnchor),
            radioDescription.trailingAnchor.constraint(equalTo: radioLine.trailingAnchor, constant: -24.0),
            
            radioLine.widthAnchor.constraint(equalToConstant: 324.0),
            radioLine.heightAnchor.constraint(equalToConstant: self.radioLineHeight)
        ])
        return radioLine
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
    
    @objc func clickRadio(_ sender: TypeUITapGestureRecognizer) {
        if let clickId = sender.type {
            self.btnMap.forEach { (id, btn) in
                if clickId == id {
                    let isSelect = btn.isSelected
                    btn.isSelected = !isSelect
                } else {
                    btn.isSelected = false
                }
            }
        }
    }
    
    @objc func confirmAlert() {
        var selectedId: String?
        var selectedMessage: String?
        self.btnMap.forEach { (id, btn) in
            if btn.isSelected {
                selectedId = id
                if let idx = self.reportTypes.firstIndex(where: { t in t.reportTypeId == selectedId } ) {
                    selectedMessage = self.reportTypes[idx].type
                }
            }
        }
        
        if let selectedId = selectedId, let memberId = self.reportUserId, let selectedMessage = selectedMessage {
            self.dismiss(animated: false) {
                self.reportAlertActionDelegate?.reportConfirm(reportId: selectedId, memberId: memberId, reportMessage: selectedMessage)
            }
        }
    }
    
    @objc func closeAlert() {
        self.dismiss(animated: false) {
            self.reportAlertActionDelegate?.reportCancel()
        }
    }
}


class TypeUITapGestureRecognizer: UITapGestureRecognizer {
    var type: String?
}
