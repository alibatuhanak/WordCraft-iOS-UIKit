//
//  UILabel+Extension.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 21.01.2025.
//
import UIKit

extension UILabel {
    
    static func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight = .regular, textColor: UIColor = .black) -> UILabel! {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}
