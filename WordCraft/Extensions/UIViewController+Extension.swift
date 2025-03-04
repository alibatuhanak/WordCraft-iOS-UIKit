//
//  UIViewController+Extension.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 18.01.2025.
//

import UIKit

extension UIViewController {
    
    var viewWidth: CGFloat {
        return view.frame.size.width
    }    
    var viewWHeight: CGFloat {
        return view.frame.size.height
    }
    
    
    func showAlertWithActions(
        title: String,
        message: String,
        actions: [UIAlertAction]?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      //  let okButton = UIAlertAction(title: "OK", style: .default)
        actions?.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: nil)
    }
}
