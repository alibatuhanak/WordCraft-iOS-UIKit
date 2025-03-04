//
//  LevelCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 30.01.2025.
//

import UIKit

class LevelCell: UICollectionViewCell {

    static let identifier: String = "LevelCell"
    
    let levelBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "container_bg")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
  
    private func setUI(){
        self.contentView.addSubview(levelBackgroundImageView)
        self.contentView.addSubview(levelLabel)
        
        
        NSLayoutConstraint.activate([
        //    contentView.widthAnchor.constraint(equalToConstant: 50),
        //    contentView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            self.levelBackgroundImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.levelBackgroundImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.levelBackgroundImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            self.levelBackgroundImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            self.levelLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.levelLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.levelLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            self.levelLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            
        ])
    }

    

}
