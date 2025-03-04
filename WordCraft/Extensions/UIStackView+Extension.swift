//
//  UIStackView+Extension.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 21.01.2025.
//
import UIKit

extension UIStackView {
    
    static  func createFormFieldStackView(_ arrangedSubviews: [UIView]) -> UIStackView{

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
      
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.alignment = .fill
        stackView.distribution = .fill 
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
          

        
        return stackView
        
    }
    
    
    static func setStackView(subViews: [UIView],axis: NSLayoutConstraint.Axis, spacing: CGFloat,alignment:  UIStackView.Alignment,distribution: UIStackView.Distribution)->UIStackView{
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        
        
        return stackView
    }
}
