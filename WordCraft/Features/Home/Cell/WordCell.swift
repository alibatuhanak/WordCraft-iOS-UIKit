//
//  WordCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 16.02.2025.
//

import UIKit

class WordCell: UICollectionViewCell //
{

    static let identifier: String = "WordCell"
    

    
    var wordLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
     //)   label.lineBreakMode = .byWordWrapping
              
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
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
        self.contentView.addSubview(wordLabel)
        contentView.layer.cornerRadius = 20
       // contentView.layer.borderWidth = 1
     //   contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
        //    contentView.widthAnchor.constraint(equalToConstant: 50),
        //    contentView.heightAnchor.constraint(equalToConstant: 50),
            
            
                     
            self.wordLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.wordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.wordLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            self.wordLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            
        ])
    }

    

}
