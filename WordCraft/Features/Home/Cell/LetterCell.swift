//
//  LevelCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 30.01.2025.
//

import UIKit

class LetterCell: UICollectionViewCell {

    static let identifier: String = "LetterCell"
    

    
    var letterLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
       // label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Delius-Regular", size: 28)
    
        
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
        self.contentView.addSubview(letterLabel)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
        //    contentView.widthAnchor.constraint(equalToConstant: 50),
        //    contentView.heightAnchor.constraint(equalToConstant: 50),
            
            
                     
            self.letterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.letterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.letterLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            self.letterLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            
        ])
    }

    

}
