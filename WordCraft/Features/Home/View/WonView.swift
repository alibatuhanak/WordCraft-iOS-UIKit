//
//  WinView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 23.02.2025.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa


class WonView: UIViewController {

    var wonStackView: UIStackView!
    
    var point: Int = 0
    
    let viewModel = WonViewModel()
    
    
    
    private func callViewModel(){
        print(point)
        bindViewModel()
        viewModel.updatePoint(newPoint: point)
        
        
    }
    
    private func bindViewModel(){
        let loadingView = LoadingView()
      
        
        viewModel.isLoading.observe(on: MainScheduler.instance).subscribe (onNext: { isLoading in
            
            if isLoading {
                loadingView.show(in: self.view)
                
                return
            }else {
                
                
                loadingView.hide()
            }
            
        })
    }
    
    lazy var lostLabel: UILabel = {
       
        let label = UILabel()
        label.text = "YOU WON \(point)"
        label.textColor = .primarypurple
        label.font = .systemFont(ofSize: 36, weight: .black)
        label.font = UIFont(name: "Delius-Regular", size: 36)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let pointImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .point
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private func setWonStackView(){
        wonStackView = .setStackView(subViews: [lostLabel, pointImage], axis: .horizontal, spacing: 5, alignment: .center, distribution: .equalSpacing)
        view.addSubview(wonStackView)
    }
    
    
    let confettiView: UIView = {
        let confettiView = LottieAnimationView(name: "win")
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
print("second")
        view.backgroundColor = .white
        
       
       
        setUI()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewModel()
        print("first")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }


    private func setUI(){
        setWonStackView()
        view.addSubview(confettiView)
       
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            
            
            wonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            confettiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confettiView.topAnchor.constraint(equalTo: wonStackView.topAnchor, constant: 30),
            confettiView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
           confettiView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: confettiView.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
            
            
            
        ])
        
    }

}
