//
//  LevelCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 30.01.2025.
//

import UIKit

class ChallengeCell: UICollectionViewCell {

    static let identifier: String = "ChallengeCell"
    
    let challengeBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challenge1")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primarypurple
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        label.textAlignment = .left
        
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3


        let firstText = NSAttributedString(string: "Math Challenge\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ])

        let attributedText = NSMutableAttributedString(attributedString: firstText)

        let secondText = NSAttributedString(string: "Practice your math skills.", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: paragraphStyle
            
        ])

        attributedText.append(secondText)

        label.attributedText = attributedText
        return label
        
    }()
    
    let forwardImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName:  "chevron.forward")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
  
    private func setUI(){
        backgroundContainerView.addSubview(challengeBackgroundImageView)
        
        
        self.contentView.addSubview(backgroundContainerView)
        self.contentView.addSubview(challengeLabel)
        self.contentView.addSubview(forwardImageView)
       
        
     //   challengeLabel.backgroundColor = .red
     //   forwardImageView.backgroundColor = .yellow
        NSLayoutConstraint.activate([
        //    contentView.widthAnchor.constraint(equalToConstant: 50),
        //    contentView.heightAnchor.constraint(equalToConstant: 50),
            
            
            self.backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            self.backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            self.backgroundContainerView.widthAnchor.constraint(equalToConstant: contentView.frame.width/5),
            
            
            self.challengeBackgroundImageView.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor),
            self.challengeBackgroundImageView.centerYAnchor.constraint(equalTo: backgroundContainerView.centerYAnchor),
            self.challengeBackgroundImageView.widthAnchor.constraint(equalTo: backgroundContainerView.widthAnchor),
            self.challengeBackgroundImageView.heightAnchor.constraint(equalTo: backgroundContainerView.heightAnchor),
            
            //self.challengeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.challengeLabel.leadingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: 20),
        //    self.challengeLabel.trailingAnchor.constraint(equalTo: forwardImageView.trailingAnchor, constant: 0),
            self.challengeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
       
//            self.forwardImageView.leadingAnchor.constraint(equalTo: challengeLabel.trailingAnchor, constant: 0),
//            self.forwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
//            self.forwardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            
            self.forwardImageView.leadingAnchor.constraint(equalTo: challengeLabel.trailingAnchor),
            self.forwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
            self.forwardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          //  self.forwardImageView.widthAnchor.constraint(equalToConstant: 50),
            self.forwardImageView.heightAnchor.constraint(equalToConstant: 50),
            
      
          //  self.challengeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
//            self.challengeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            
        ])
    }

    

}
