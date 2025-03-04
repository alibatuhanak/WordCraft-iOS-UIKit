//
//  NSAttributedString+Extension.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 22.01.2025.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func createAttributedString(normalText: String, boldText: String, boldFontSize: CGFloat, normalColor: UIColor, boldColor: UIColor) -> NSAttributedString {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: normalColor
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: boldFontSize),
            .foregroundColor: boldColor,
            
        ]
            
        let attributedString = NSMutableAttributedString(
            string: normalText,
            attributes: normalAttributes
        )
        attributedString
            .append(
                NSAttributedString(string: boldText, attributes: boldAttributes)
            )
            
        return attributedString
    }
}
