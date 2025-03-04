//
//  LeaderboardItemCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 3.02.2025.
//

import UIKit

class LeaderboardItemCell: UICollectionViewCell {
    

    static let identifier: String = "LeaderboardItemCell"
        
    
    var containerStackView : UIStackView!
    var profileStackView : UIStackView!
    var userStatsStackView : UIStackView!
    var pointStackView : UIStackView!
    
//    let view = UIStackView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = .red
//    view.layer.cornerRadius = 15
//    šview.layer.masksToBounds = true
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "05"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    

    
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "panda50")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 25
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
        let pointImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "point")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
        var pointLabel: UILabel = {
            let label = UILabel()
            label.text = "750 pts"
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = .gray
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
            
        }()
    
    
       
        var usernameLabel: UILabel = {
            let label = UILabel()
            label.text = "Jennifer"
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textColor = .black
            label.textAlignment = .left
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
            pointStackView = .setStackView(subViews: [pointImageView, pointLabel], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fill)
            
            userStatsStackView = .setStackView(subViews: [usernameLabel, pointStackView], axis: .horizontal, spacing:0, alignment: .leading, distribution: .fillEqually)
            profileStackView = .setStackView(subViews: [profileImageView, userStatsStackView], axis: .horizontal, spacing: 10, alignment: .center, distribution: .fill)
            containerStackView = .setStackView(subViews: [rankLabel, profileStackView], axis: .horizontal, spacing: 20, alignment: .center, distribution: .fill)

            containerStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 10)
            containerStackView.isLayoutMarginsRelativeArrangement = true
            
            containerStackView.translatesAutoresizingMaskIntoConstraints = false
            profileStackView.translatesAutoresizingMaskIntoConstraints = false
            userStatsStackView.translatesAutoresizingMaskIntoConstraints = false
            pointStackView.translatesAutoresizingMaskIntoConstraints = false
          //  userStatsStackView.backgroundColor = .red
            
            //profileStackView.layer.borderWidth = 1
            //profileStackView.layer.borderColor = UIColor(red: 244/255, green: 248/255, blue: 249/255, alpha: 1).cgColor
            profileStackView.layer.cornerRadius = 10
            profileStackView.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 242/255, alpha: 1)
            
            
            profileStackView.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        
            profileStackView.isLayoutMarginsRelativeArrangement = true
            
//            containerStackView.backgroundColor = .purple
//            profileStackView.backgroundColor = .red
//            userStatsStackView.backgroundColor = .gray
//            pointStackView.backgroundColor = .yellow
//            
            self.contentView.addSubview(containerStackView)
            
            //containerStackView.backgroundColor = .red
            NSLayoutConstraint.activate([
        
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50),
                
           //     rankLabel.widthAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
                
                containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                //userStatsStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
                
            ])
        }

        

    }
