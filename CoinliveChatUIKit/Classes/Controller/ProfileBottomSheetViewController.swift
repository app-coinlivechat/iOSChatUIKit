//
//  ProfileBottomSheetViewController.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/29.
//

import UIKit
import CoinliveChatSDK

class ProfileBottomSheetViewController: UIViewController {
    private weak var btnClose: UIButton?
    private weak var ivProfile: UIImageView?
    private weak var lbNickname: UILabel?
    private weak var lbFromCustomer: UILabel?
    
    private let closeButtonSize: CGFloat = 24.0
    private let profileImageSize: CGFloat = 82.0
    
    internal var nickname: String? = nil
    internal var profileUrl: String? = nil
    internal var isNft: Bool? = nil
    internal var exchange: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundBottomSheet
        
        bottomSheetTransitioningDelegate.preferredSheetTopInset = 70.0
        
        let vIndicator = UIView()
        vIndicator.translatesAutoresizingMaskIntoConstraints = false
        vIndicator.backgroundColor = .bottomSheetIndicatorProfile
        vIndicator.layer.cornerRadius = 2.0
        self.view.addSubview(vIndicator)
        
        let btnClose = UIButton(type: .custom)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.setImage(.close, for: .normal)
        btnClose.setImage(.close.withTintColor(.init(white: 1, alpha: 0.5)), for: .highlighted)
        btnClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
        
        self.view.addSubview(btnClose)
        self.btnClose = btnClose
        
        let ivProfile = UIImageView()
        ivProfile.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(ivProfile)
        self.ivProfile = ivProfile
        
        let lbNickname = UILabel()
        lbNickname.translatesAutoresizingMaskIntoConstraints = false
        lbNickname.font = UIFont.systemFont(ofSize: 20)
        lbNickname.textColor = .label
        lbNickname.textAlignment = .center
        
        self.view.addSubview(lbNickname)
        self.lbNickname = lbNickname
        
        let lbFromCustomer = UILabel()
        lbFromCustomer.translatesAutoresizingMaskIntoConstraints = false
        lbFromCustomer.font = UIFont.systemFont(ofSize: 18.0)
        lbFromCustomer.textColor = .labelYellow
        lbFromCustomer.textAlignment = .center
        
        self.view.addSubview(lbFromCustomer)
        self.lbFromCustomer = lbFromCustomer
        
        NSLayoutConstraint.activate([
            vIndicator.widthAnchor.constraint(equalToConstant: self.view.bounds.size.width / 6.0),
            vIndicator.heightAnchor.constraint(equalToConstant: 4.0),
            vIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            vIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0),
            
            btnClose.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12.0),
            btnClose.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12.0),
            btnClose.widthAnchor.constraint(equalToConstant: self.closeButtonSize),
            btnClose.heightAnchor.constraint(equalToConstant: self.closeButtonSize),
            
            ivProfile.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ivProfile.topAnchor.constraint(equalTo: btnClose.bottomAnchor),
            ivProfile.widthAnchor.constraint(equalToConstant: self.profileImageSize),
            ivProfile.heightAnchor.constraint(equalToConstant: self.profileImageSize),
            
            lbNickname.topAnchor.constraint(equalTo: ivProfile.bottomAnchor, constant: 7.0),
            lbNickname.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            lbFromCustomer.topAnchor.constraint(equalTo: lbNickname.bottomAnchor, constant: 25.0),
            lbFromCustomer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        // TODO exchange 값 api 추가 요청
        
        lbNickname.text = self.nickname ?? "알수없음"
        lbFromCustomer.text = self.exchange ?? "알수없음"
        
        ivProfile.clipsToBounds = true
        ivProfile.layer.cornerRadius = self.profileImageSize / 2.0
        if let isNft = self.isNft {
            if isNft {
                ivProfile.layer.cornerRadius = 12.0
            }
        }
        
        if let profileString = self.profileUrl, let url = NSURL(string: profileString) {
            ImageCache.shared.load(url: url, completion: { (fetchImage) in
                guard let fetchImage = fetchImage else {
                    DispatchQueue.main.async {
                        ivProfile.image = .baseProfile
                    }
                    return
                }
                DispatchQueue.main.async {
                    ivProfile.image = fetchImage.centerCrop() ?? .baseProfile
                }
            })
        } else {
            DispatchQueue.main.async {
                ivProfile.image = .baseProfile
            }
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    enum PreferredSheetSizing: CGFloat {
        case small = 0.25
    }
    
    private lazy var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(
        preferredSheetTopInset: 24.0,
        preferredSheetCornerRadius: 24.0,
        preferredSheetSizingFactor: 257,
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

