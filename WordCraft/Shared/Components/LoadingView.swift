//
//  LoadingView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 19.02.2025.
//

import UIKit

class LoadingView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isHidden = true
        
        activityIndicator.center = self.center
        activityIndicator.color = .white
        self.addSubview(activityIndicator)
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hide() {
        self.isHidden = true
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
