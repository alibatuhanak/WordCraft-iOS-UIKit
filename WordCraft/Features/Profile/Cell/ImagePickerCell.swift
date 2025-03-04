//
//  ImagePickerCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 9.02.2025.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {
    


        static let identifier: String = "ImagePickerCell"
        
         
        var avatarImageView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"panda50")
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
            contentView.layer.cornerRadius = contentView.frame.width/2
            contentView.layer.masksToBounds = true
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.black.cgColor
            
            
            self.contentView.addSubview(avatarImageView)
           

            NSLayoutConstraint.activate([

                
                avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                avatarImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                
                
            ])
        }

        

    }
