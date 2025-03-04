//
//  HomeView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AuthenticationView: UIViewController {

    private var wordgenLogo: UIImageView  = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logolast")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
        
    }()

  

  

  

    deinit {
        print("auth de init")
    }
    
    private lazy var goToRegisterPageButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToRegisterPageButtonClicked), for: .touchUpInside)
      
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
    
        
        var configuration = UIButton.Configuration.filled()
       configuration.title = title
        configuration.baseBackgroundColor = .primarypurple
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
          
        button.configuration = configuration
        

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
       // button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
      button.layer.masksToBounds = true
        
        return button
        
    }()
    
    private func  containerView(button: UIButton) -> UIView {
        let containerView = UIView()
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.35
        containerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
      
        return containerView
        
    }
    private lazy var goToLoginPageButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("I already have an account", for: .normal)
        button.setTitleColor(.primarypurple, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToLoginPageButtonClicked), for: .touchUpInside)

        button.layer.borderWidth = 1
        button.layer.borderColor =   UIColor.primarypurple.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        button.layer.cornerRadius = 10
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .white
     
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
          
        button.configuration = configuration
        button.clipsToBounds = true

        return button
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
       // label.text = "WordCraft: Kelimeleri Yarat, Zekanı Konuştur!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Çok satırlı metin için
        label.textAlignment = .center // Metni ortala
        
        let title = "WordGen\nCreate Words and Showcase Your Intelligence!\n\n"
        let subtitle = "A perfect game for word enthusiasts! WordGen challenges your vocabulary with new difficulties and fun puzzles at every level."

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .black),
            .foregroundColor:    UIColor.primarypurple
            
        ]

        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkGray
        ]

        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributedText = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        attributedText.append(subtitleAttributedText)

        label.attributedText = attributedText
        return label
    }()
    
    @objc private func goToRegisterPageButtonClicked(){
        let registerPageViewController = RegisterView()
        registerPageViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(registerPageViewController, animated: true)
    }
        
    @objc private func goToLoginPageButtonClicked(){
        let loginPageViewController = LoginView()
        
        loginPageViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(loginPageViewController, animated: true)
    }
    
    
      
    fileprivate func setGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.oldColor.cgColor,
            UIColor.oldColor.cgColor,
            UIColor.secondaryColor.cgColor,
            UIColor.secondaryColor.cgColor,
            UIColor.secondaryColor.cgColor,
          UIColor.primaryColor.cgColor,
          
          
        
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = goToRegisterPageButton.bounds
        
        if let existingLayer = goToRegisterPageButton.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingLayer.removeFromSuperlayer()
        }
       
        goToRegisterPageButton.layer.insertSublayer(gradientLayer, at: 0)
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientLayer()
       
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .primarypurple
       
        setUI()
    }
    
    private func setUI(){
      //  view.backgroundColor = UIColor(red: 80/255, green: 215/255, blue: 245/255, alpha: 1.0)
        
        let loginContainerView = containerView(button: goToLoginPageButton)
        let registerContainerView = containerView(button: goToRegisterPageButton)
        
        view.backgroundColor = .white
        view.addSubview(wordgenLogo)
        view.addSubview(loginContainerView)
        view.addSubview(registerContainerView)
        view.addSubview(contentLabel)
        
        
        NSLayoutConstraint.activate([
            wordgenLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height*0.1),
            wordgenLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
           //wordgenLogo.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            wordgenLogo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:0.3 ),
            wordgenLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 25),
            wordgenLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor  , constant: -25),
            
            
            contentLabel.topAnchor.constraint(equalTo: wordgenLogo.bottomAnchor, constant: 15 ),
            contentLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            
            registerContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5),
            registerContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            registerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
               
            
            goToRegisterPageButton.centerXAnchor.constraint(equalTo: registerContainerView.centerXAnchor),
            goToRegisterPageButton.centerYAnchor.constraint(equalTo: registerContainerView.centerYAnchor),
            goToRegisterPageButton.widthAnchor.constraint(equalTo: registerContainerView.widthAnchor),
            goToRegisterPageButton.heightAnchor.constraint(equalTo: registerContainerView.heightAnchor),
            
            
            loginContainerView.topAnchor.constraint(equalTo: registerContainerView.bottomAnchor, constant: 15),
            loginContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            loginContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.size.height*0.2),
               
            goToLoginPageButton.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor),
            goToLoginPageButton.centerYAnchor.constraint(equalTo: loginContainerView.centerYAnchor),
            goToLoginPageButton.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor),
            goToLoginPageButton.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor),

           

        
        ])
    }
    

}
