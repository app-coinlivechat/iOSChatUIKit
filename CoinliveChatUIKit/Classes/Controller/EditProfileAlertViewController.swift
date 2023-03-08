//
//  EditProfileAlertViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/21.
//

import UIKit

class EditProfileAlertViewController: UIViewController {
    public weak var editProfileDelegate: EditProfileDelegate?
    private let profileImageSize: CGFloat = 82.0
    private let captureIconSize: CGFloat = 32.0
    private let cancelIconSize: CGFloat = 20.0
    
    var nickname: String? = nil
    var profileUrl: String? = nil
    private var chooseImage: Data? = nil
    
    private weak var tfNickname: UITextField?
    private weak var btnEditCancel: UIButton?
    private weak var ivProfile: UIImageView?
    
    private let alertWidth = 300.0
    private let alertHeight = 245.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        let alertView = UIView()
        alertView.layer.cornerRadius = 16
        alertView.backgroundColor = .backgroundPopup
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(alertView)
        
        let ivProfile = UIImageView()
        ivProfile.layer.cornerRadius = self.profileImageSize / 2.0
        ivProfile.clipsToBounds = true
        ivProfile.translatesAutoresizingMaskIntoConstraints = false
        ivProfile.isUserInteractionEnabled = true 
        ivProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickProfileImageView)))
        
        alertView.addSubview(ivProfile)
        self.ivProfile = ivProfile
        
        let ivIcon = UIButton(type: .custom)
        ivIcon.setImage(.capture, for: .normal)
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        ivIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickCaptureIcon)))
        
        alertView.addSubview(ivIcon)
        
        let tfNickname = UITextField()
        tfNickname.translatesAutoresizingMaskIntoConstraints = false
        tfNickname.font = UIFont.systemFont(ofSize: 16.0)
        tfNickname.textAlignment = .center
        tfNickname.borderStyle = .none
        tfNickname.textColor = .label
        tfNickname.tintColor = .primary
        tfNickname.delegate = self
        
        alertView.addSubview(tfNickname)
        self.tfNickname = tfNickname
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .primary
        alertView.addSubview(border)
        
        let btnEditCancel = UIButton(type: .custom)
        btnEditCancel.translatesAutoresizingMaskIntoConstraints = false
        btnEditCancel.setImage(.cancel, for: .normal)
        btnEditCancel.isHidden = true
        btnEditCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.editCancel)))
        alertView.addSubview(btnEditCancel)
        self.btnEditCancel = btnEditCancel
        
        let btnCancel = self.createTextButton(title: "common_cancel".localized(), backgroundColor: .backgroundPopupCancel, titleColor: .labelPopupCancel, fontSize: 16.0)
        btnCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAlert)))
        let btnSave = self.createTextButton(title: "common_save".localized(), backgroundColor: .primary, titleColor: .white, fontSize: 16.0)
        btnSave.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.confirmAlert)))
        
        alertView.addSubview(btnCancel)
        alertView.addSubview(btnSave)
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: self.alertWidth),
            alertView.heightAnchor.constraint(equalToConstant: self.alertHeight),
            
            ivProfile.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20.0),
            ivProfile.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            ivIcon.trailingAnchor.constraint(equalTo: ivProfile.trailingAnchor),
            ivIcon.bottomAnchor.constraint(equalTo: ivProfile.bottomAnchor),
            ivIcon.heightAnchor.constraint(equalToConstant: self.captureIconSize),
            ivIcon.widthAnchor.constraint(equalToConstant: self.captureIconSize),
            
            tfNickname.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16.0),
            tfNickname.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16.0),
            tfNickname.topAnchor.constraint(equalTo: ivProfile.bottomAnchor, constant: 32.0),
            
            border.leadingAnchor.constraint(equalTo: tfNickname.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: tfNickname.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: tfNickname.bottomAnchor, constant: 8.0),
            border.heightAnchor.constraint(equalToConstant: 1.0),
            
            btnEditCancel.trailingAnchor.constraint(equalTo: tfNickname.trailingAnchor),
            btnEditCancel.centerYAnchor.constraint(equalTo: tfNickname.centerYAnchor),
            btnEditCancel.widthAnchor.constraint(equalToConstant: self.cancelIconSize),
            btnEditCancel.heightAnchor.constraint(equalToConstant: self.cancelIconSize),
            
            btnCancel.leadingAnchor.constraint(equalTo: tfNickname.leadingAnchor),
            btnCancel.topAnchor.constraint(equalTo: tfNickname.bottomAnchor, constant: 20.0),
            btnCancel.trailingAnchor.constraint(equalTo: btnSave.leadingAnchor, constant: -8.0),
            btnCancel.widthAnchor.constraint(equalTo: btnSave.widthAnchor),
            btnCancel.heightAnchor.constraint(equalToConstant: 48.0),
            
            btnSave.leadingAnchor.constraint(equalTo: btnCancel.trailingAnchor, constant: 8.0),
            btnSave.topAnchor.constraint(equalTo: tfNickname.bottomAnchor, constant: 20.0),
            btnSave.trailingAnchor.constraint(equalTo: tfNickname.trailingAnchor),
            btnSave.heightAnchor.constraint(equalToConstant: 48.0),
            btnSave.widthAnchor.constraint(equalTo: btnCancel.widthAnchor)
        ])
        
        
        tfNickname.text = self.nickname
        self.loadImage()
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
    
    @objc func clickProfileImageView() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true , completion: nil)
        }
    }
    
    @objc func clickCaptureIcon() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true , completion: nil)
        }
    }
    
    @objc func confirmAlert() {
        self.dismiss(animated: false) {
            if let changedNickname = self.tfNickname?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if changedNickname.count > 0 && self.nickname != changedNickname {
                    self.editProfileDelegate?.saveEditProfile(nickname: changedNickname, profileImage: self.chooseImage)
                    return
                }
            }
            self.editProfileDelegate?.saveEditProfile(nickname: nil, profileImage: self.chooseImage)
        }
    }
    
    @objc func closeAlert() {
        self.dismiss(animated: false) {
            self.editProfileDelegate?.cancelEditProfile()
        }
    }
    
    @objc func editCancel() {
        self.tfNickname?.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event) //
        self.view.endEditing(true)
        self.btnEditCancel?.isHidden = true
    }
    
    private func loadImage() {
        if let urlString = self.profileUrl, let url = NSURL(string: urlString) {
            ImageCache.shared.load(url: url, completion: { (fetchImage) in
                guard let fetchImage = fetchImage else {
                    return
                }
                DispatchQueue.main.async {
                    self.ivProfile?.image = fetchImage.centerCrop()
                }
                
            })
        } else {
            DispatchQueue.main.async {
                self.ivProfile?.image = .baseProfile
            }
        }
    }
}

extension EditProfileAlertViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.btnEditCancel?.isHidden = true
            return true
        }
        
        if text.count < 1 {
            self.btnEditCancel?.isHidden = true
            return true
        }
        self.btnEditCancel?.isHidden = false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.btnEditCancel?.isHidden = true
            return
        }
        
        if text.count < 1 {
            self.btnEditCancel?.isHidden = true
            return
        }
        self.btnEditCancel?.isHidden = false
    }
}

extension EditProfileAlertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imageExtension = imageUrl.pathExtension
            var imageData: Data? = nil
            if imageExtension.uppercased() == "JPEG" {
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                imageData = image.jpegData(compressionQuality: 0.7)
            } else if imageExtension.uppercased() == "PNG" {
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                imageData = image.pngData()
            } else {
                return
            }
            
            self.chooseImage = imageData
            if let data = imageData {
                DispatchQueue.main.async {
                    self.ivProfile?.image = UIImage(data: data)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
