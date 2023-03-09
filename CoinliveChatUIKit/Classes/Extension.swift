//
//  Extension.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/11/11.
//

import UIKit
import Foundation

extension UIColor {
    class var primary: UIColor { return .load(name: "primary") }
    class var background: UIColor { return .load(name: "background") }
    class var label: UIColor { return .load(name: "label") }
    class var labelSystem: UIColor { return .load(name: "label_system") }
    class var labelMessageDate: UIColor { return .load(name: "label_message_date") }
    class var boxMessage: UIColor { return  .load(name: "box_message") }
    class var boxMessageSystem: UIColor { return  .load(name: "box_message_system") }
    class var boxMessageText: UIColor { return  .load(name: "box_message_text") }
    class var boxMessageInputPlaceholder: UIColor { return  .load(name: "box_message_input_placeholder") }
    class var headerDivider: UIColor { return  .load(name: "header_border") }
    class var moreActionDivider: UIColor { return  .load(name: "more_action_divider") }
    class var ama: UIColor { return  .load(name: "ama_primary") }
    class var assetComment: UIColor { return  .load(name: "asset_comment") }
    class var boxAsset: UIColor { return  .load(name: "box_asset") }
    class var boxAssetBorder: UIColor { return  .load(name: "box_asset_border") }
    class var settingDivider: UIColor { return  .load(name: "setting_divider") }
    class var backgroundPopup: UIColor { return  .load(name: "background_popup") }
    class var bottomsheetIndicator: UIColor { return  .load(name: "bottomsheet_indicator") }
    class var backgroundPopupSelected: UIColor { return  .load(name: "background_popup_selected") }
    class var backgroundPopupCancel: UIColor { return  .load(name: "background_popup_cancel") }
    class var backgroundPopupPrimary: UIColor { return  .load(name: "background_popup_confirm_primary") }
    class var backgroundPopupRed: UIColor { return  .load(name: "background_popup_confirm_red") }
    class var labelPopupCancel: UIColor { return  .load(name: "label_popup_cancel") }
    class var btnNotice: UIColor { return  .load(name: "label_notice_btn") }
    class var backgroundNotice: UIColor { return  .load(name: "background_notice") }
    class var borderNotice: UIColor { return  .load(name: "notice_border") }
    class var innterBorderNotice: UIColor { return  .load(name: "notice_inner_border") }
    class var backgroundBottomSheet: UIColor { return  .load(name: "background_bottom_sheet") }
    class var labelYellow: UIColor { return  .load(name: "label_yellow") }
    class var bottomSheetIndicatorProfile: UIColor { return  .load(name: "bottomsheet_indicator_profile") }
    class var backgroundDropDown: UIColor { return  .load(name: "background_drop_down") }
    class var backgroundNewMessage: UIColor { return  .load(name: "background_new_message") }
    class var labelNewMessageNickname: UIColor { return  .load(name: "label_new_message_nickname") }
    class var borderMenu: UIColor { return  .load(name: "menu_border") }
    class var labelMenuWarning: UIColor { return  .load(name: "label_menu_warning") }
    class var backgroundEmoji: UIColor { return  .load(name: "background_emoji") }
    class var backgroundAma: UIColor { return  .load(name: "background_ama") }
    class var backgroundFailedMessageController: UIColor { return  .load(name: "background_failed") }
    class var backgroundAnonymousInput: UIColor { return  .load(name: "box_input_anonymous") }
    class var labelAnonymous: UIColor { return  .load(name: "label_message_anonymous") }
    class var backgroundToast: UIColor { return  .load(name: "box_toast") }
}

extension UIImage {
    class var fold: UIImage { return .load(name: "ic_fold") }
    class var more: UIImage { return .load(name: "ic_more") }
    class var userCount: UIImage { return .load(name: "ic_user_count") }
    class var share: UIImage { return .load(name: "ic_share") }
    class var setting: UIImage { return .load(name: "ic_setting") }
    class var translateSetting: UIImage { return .load(name: "ic_translate_setting") }
    class var plus: UIImage { return .load(name: "ic_plus") }
    class var send: UIImage { return .load(name: "ic_send_message") }
    class var binance: UIImage { return .load(name: "ic_binance") }
    class var jumpAndDrop: UIImage { return .load(name: "ic_drop_jump") }
    class var twitter: UIImage { return .load(name: "ic_twitter") }
    class var medium: UIImage { return .load(name: "ic_medium") }
    class var byGoogle: UIImage { return .load(name: "ic_by_google") }
    class var imgLoadFailed: UIImage { return .load(name: "img_failed") }
    class var back: UIImage { return .load(name: "ic_back") }
    class var rightArrow: UIImage { return .load(name: "ic_right_arrow") }
    class var check: UIImage { return .load(name: "ic_check_active") }
    class var unCheck: UIImage { return .load(name: "ic_check_inactive") }
    class var rightArrowWhite: UIImage { return .load(name: "ic_right_arrow_white") }
    class var notice: UIImage { return .load(name: "ic_notice") }
    class var cancel: UIImage { return .load(name: "ic_cancel") }
    class var close: UIImage { return .load(name: "ic_close") }
    class var baseProfile: UIImage { return .load(name: "img_base_profile") }
    class var menuProfile: UIImage { return .load(name: "ic_menu_profile") }
    class var capture: UIImage { return .load(name: "ic_capture") }
    class var heart: UIImage { return .load(name: "img_heart") }
    class var clap: UIImage { return .load(name: "img_clap") }
    class var good: UIImage { return .load(name: "img_good") }
    class var rocket: UIImage { return .load(name: "img_rocket") }
    class var cry: UIImage { return .load(name: "img_cry") }
    class var astonished: UIImage { return .load(name: "img_astonished") }
    class var copy: UIImage { return .load(name: "ic_copy") }
    class var report: UIImage { return .load(name: "ic_report") }
    class var block: UIImage { return .load(name: "ic_block") }
    class var downArrow: UIImage { return .load(name: "ic_arrow_down") }
    class var pressed: UIImage { return .load(name: "img_pressed") }
    class var radioActive: UIImage { return .load(name: "ic_radio_active") }
    class var radioInactive: UIImage { return .load(name: "ic_radio_inactive") }
    class var blockedUserImageMessage: UIImage { return .load(name: "img_block_user_image") }
    class var iconBithumb: UIImage { return .load(name: "img_bithumb") }
    class var iconUpbit: UIImage { return .load(name: "img_upbit") }
    class var iconCoinone: UIImage { return .load(name: "img_coinone") }
    class var iconBinance: UIImage { return .load(name: "img_binance") }
    class var iconMetamask: UIImage { return .load(name: "img_metamask") }
    class var resend: UIImage { return .load(name: "ic_failed_resend") }
    class var resendCancel: UIImage { return .load(name: "ic_failed_cancel") }
}

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, bundle: Bundle.frameworkBundle, comment: comment)
    }
    func localized(with argument: CVarArg..., comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}

extension Bundle {
    private class CoinliveChatUIKIt {}
    
    static var frameworkBundle: Bundle {
        return Bundle(for: CoinliveChatUIKIt.self)
    }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        if let image = UIImage(named: name, in: Bundle.frameworkBundle, compatibleWith: nil) {
            return image
        } else {
            return UIImage(systemName: "info.circle.fill")!
        }
    }
    
    func resizeWithWidth(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
    func resizeWithHeight(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    // https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    func centerCrop() -> UIImage?
    {
        let sideLength = min(
            self.size.width,
            self.size.height
        )
        
        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = self.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0
        
        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral
        
        // Center crop the image
        let sourceCGImage = self.cgImage!
        if let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        ) {
            
            let croppedImage: UIImage = UIImage(cgImage: croppedCGImage)
            return croppedImage
        }
        return nil
        
    }
}
extension UIColor {
    static func load(name: String) -> UIColor {
        if let color = UIColor(named: name, in: Bundle.frameworkBundle, compatibleWith: nil) {
            return color
        } else {
            return UIColor.white
//            fatalError("색상 로드 실패")
        }
    }
}

extension Int {
    func makeDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self)!
    }
}

extension Int64 {
    func convertDateFormat(form: String, locale: Locale) -> String {
        let format = DateFormatter()
        format.dateFormat = form
        format.locale = locale
        return format.string(from: Date(timeIntervalSince1970: Double(integerLiteral: self/1000)))
    }
    
    func convertTableKey() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        return format.string(from: Date(timeIntervalSince1970: Double(integerLiteral: self/1000)))
    }
    
    func gapOfTimestampByMinute(target: Int64) -> Bool {
        let format = DateFormatter()
        format.dateFormat = "HHmm"
        let own = format.string(from: Date(timeIntervalSince1970: Double(integerLiteral: self/1000)))
        let other = format.string(from: Date(timeIntervalSince1970: Double(integerLiteral: target/1000)))
        return own == other
    }
}
extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}

extension String {
    func isCoinMatches() -> Bool {
        return self.range(of: ":CL\\$([a-zA-Z]*)-([A-Z]*)-([A-Z]*)\\|(\\d*)CL:", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isUserMatches() -> Bool {
        return self.range(of: ":CL@([\\da-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]*)\\_([\\d]*)CL:", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func toCoinMatches() -> String {
        if let parseRegex = try? NSRegularExpression(pattern: "\\$([a-zA-Z]*)-([A-Z]*)-([A-Z]*)") {
            if let result = parseRegex.matches(in: self,
                                               range: NSRange(self.startIndex..., in: self)).first {
                if let range = Range(result.range, in: self) {
                    return String(self[range])
                }
            }
        }
        return ""
    }
    
    func toUserMatches() -> String {
        if let parseRegex = try? NSRegularExpression(pattern: "@([\\da-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]*)") {
            if let result = parseRegex.matches(in: self,
                                               range: NSRange(self.startIndex..., in: self)).first {
                if let range = Range(result.range, in: self) {
                    return String(self[range])
                }
            }
        }
        return ""
    }
}
extension UIViewController {
    func showToast(message : String, font: UIFont, keyboardFrameHeight: CGFloat = 0.0) {
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - width/2, y: self.view.frame.size.height - (100 + keyboardFrameHeight), width: width, height: 35))
        let toastLabel = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = .backgroundToast.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 18;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(100 + keyboardFrameHeight)),
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 36.0),
            toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 10.0),
            toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -10.0),
        ])
        
        UIView.animate(withDuration: 2.0,
                       animations: {
            toastLabel.alpha = 0.4
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

