
import UIKit

class AchievementItemCell: UICollectionViewCell {
    

    static let identifier: String = "AchievementItemCell"
        
    
    var containerStackView : UIStackView!

    
    let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "05"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    let badgeImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "badge3"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
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
            contentView.layer.cornerRadius = 5
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.layer.shadowRadius = 4
            contentView.layer.masksToBounds = false

            
            
            
            contentView.backgroundColor = .primarypurple
            
            containerStackView = .setStackView(subViews: [badgeImageView, badgeLabel], axis: .vertical, spacing: 0, alignment: .center, distribution: .fillEqually)
            
            containerStackView.translatesAutoresizingMaskIntoConstraints = false
            
            containerStackView.isLayoutMarginsRelativeArrangement = true
            containerStackView.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)

         //   badgeLabel.backgroundColor = .white
            
            self.contentView.addSubview(containerStackView)
            
            NSLayoutConstraint.activate([
             
                containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

                
                
            ])
        }

        

    }
