//
//  KeyboardHandler.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 22.01.2025.
//

import Foundation
import UIKit


class KeyboardHandler {
    var isExpand: Bool

    init(isExpand: Bool = false) {
        self.isExpand = isExpand
    }
    
    
    
    func keyboardAppear(viewController: UIViewController, scrollView: UIScrollView ){
        print("keyboard appeared")

        if !isExpand {
            print("expand is true")
//            if let view = sender.object as? UIView,
//               let scrollView = view.superview?.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
//                 print("141041414141")
//                view.frame.origin.y -= 200
//                scrollView.contentSize = CGSize(width: view.frame.width, height: scrollView.frame.height + 100)
//                isExpand = true
//            }
            scrollView.isScrollEnabled = true
            viewController.view.frame.origin.y -= 200
            scrollView.contentSize = CGSize(width: viewController.viewWidth, height: scrollView.frame.height + 100)
                       isExpand = true
        }
    }
    
    
      func dismissKeyboard(viewController: UIViewController) {
        //view.frame.origin.y = 0
       // scrollView.contentInset = .zero
      //  scrollView.scrollIndicatorInsets = .zero
        print("dismisss")
//        if let view = sender.view {
//               // ViewController'ı almak için hiyerarşiyi kontrol et
//               var responder: UIResponder? = view
//               while responder != nil {
//                   if let viewController = responder as? UIViewController {
//                       viewController.view?.endEditing(true)
//                       print("Found ViewController: \(viewController)")
//                       break
//                   }
//                   responder = responder?.next
//               }
//           }
     
        viewController.view.endEditing(true)
    }
    

     func keyboardDisappear(viewController: UIViewController, scrollView: UIScrollView){
        // Reset the view's origin to the initial position (0,0)
          // self.scrollView.contentSize = CGSize(width: self.viewWidth, height: scrollView.frame.height - 100)
            isExpand = false
//        if let view = sender.object as? UIView,
//           let scrollView = view.superview?.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
//            UIView.animate(withDuration: 0.3) {
//                view.frame.origin.y = 0
//               view.frame.origin.y = 0
//            }
//        }
        scrollView.isScrollEnabled = false
         viewController.view.frame.origin.y = 0
         viewController.view.frame.origin.y = 0
    }
}
