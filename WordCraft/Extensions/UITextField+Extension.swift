//
//  UITextField+Extension.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 22.01.2025.
//

import Foundation
import UIKit


extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
    
    
    static  func createTextField(placeholder: String,inputIcon: UIImage, iconClicked: Selector,viewController: UIViewController) -> UITextField {
        let textField = UITextField()
        //   textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textFieldBackgroundColor
        textField.textColor = .darkGray
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.tintColor = .primarypurple
        
        if placeholder == "Your Password" {
            textField.isSecureTextEntry = true
        }
        
        textField.layer.cornerRadius = 15
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(
            width: 2,
            height: 2
        )
        textField.layer.shadowRadius = 4
        
        let leftPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height)
        )
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let placeholderColor = UIColor.gray
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        let iconImageView = UIImageView()
        iconImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: viewController, action: iconClicked)
        iconImageView.addGestureRecognizer(tapGesture)
        
        iconImageView.image = inputIcon
        iconImageView.tintColor = .primarypurple
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: 20,
            height: 20
        )

       
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 35, height: 20)
        )
        paddingView.addSubview(iconImageView)
        //    paddingView.backgroundColor = .red

        iconImageView.center = CGPoint(
            x: 12,
            y: paddingView.frame.size.height / 2
        )

        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
