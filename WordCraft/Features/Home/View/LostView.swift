//
//  WinView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 23.02.2025.
//

import UIKit
import Lottie


class LostView: UIViewController {

    
    let lostLabel: UILabel = {
       
        let label = UILabel()
        label.text = "YOU LOST"
        label.textColor = .primarypurple
        label.font = .systemFont(ofSize: 36, weight: .black)
        label.font = UIFont(name: "Delius-Regular", size: 36)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    
    let confettiView: UIView = {
        let confettiView = LottieAnimationView(name: "loss")
        confettiView.contentMode = .scaleAspectFit
        confettiView.loopMode = .loop
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        confettiView.play { (finished) in
            confettiView.removeFromSuperview()
        }
        return confettiView
        
    }()
    
    lazy var  button: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Home", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .primarypurple
        button.layer.cornerRadius = 15
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
       
        configuration.baseBackgroundColor = .primarypurple
          configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5)
        
          button.configuration = configuration
        
        return button
        
        
    }()
    
    @objc func buttonClicked(){
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
       
       
        setUI()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }


    private func setUI(){
        view.addSubview(confettiView)
        view.addSubview(lostLabel)
        view.addSubview(button)
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            lostLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lostLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            
            confettiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confettiView.topAnchor.constraint(equalTo: lostLabel.topAnchor, constant: 30),
            confettiView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
          confettiView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: confettiView.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
            
            
            
        ])
        
    }

}
