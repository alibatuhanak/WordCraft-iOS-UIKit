//
//  ProfileItemCell.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 9.02.2025.
//

import UIKit




class ProfileItemCell: UICollectionViewCell {
    


    static let identifier: String = "ProfileItemCell"
            
        
    var containerStackView : UIStackView!
    var labelStackView : UIStackView!
    var toggleIsExist: Bool = false

        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "change username"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
            
    }()
        

        
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let navigationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .primarypurple
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .primarypurple
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
        
         
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
            
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
            
    
    
//    lazy var toggleSwitch: UISwitch? = {
//        let toggle = UISwitch()
//        toggle.onTintColor = .red
//        toggle.translatesAutoresizingMaskIntoConstraints = false
//        toggle.setOn(true, animated: true)
//        return toggle
//    }()
//    
    var toggleSwitch: UISwitch?
    
    func configure(showExtraView: Bool) {
        if showExtraView {
            if toggleSwitch == nil { // Eğer yoksa oluştur
                        let toggle = UISwitch()
                toggle.onTintColor = .primarypurple
                        toggle.translatesAutoresizingMaskIntoConstraints = false
                        toggle.setOn(true, animated: true)
                
                //containerStackView.removeArrangedSubview(navigationIconView)
                navigationIconView.removeFromSuperview()
                containerStackView.addArrangedSubview(toggle)
                toggleSwitch = toggle
            }
        } else {
            toggleSwitch?.removeFromSuperview() 
            toggleSwitch = nil
        }
    }
    
    
    private func setUI(){
        iconContainer.addSubview(iconImageView)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        
        labelStackView = .setStackView(subViews: [iconContainer, titleLabel], axis: .horizontal, spacing: 10, alignment: .center, distribution: .fill)
        
        
     //   if toggleIsExist {
            
        
    //    containerStackView = .setStackView(subViews: [labelStackView,toggleSwitch,  navigationIconView], axis: .horizontal, spacing: 10, alignment: .center, distribution: .equalSpacing)
    //    } else {
            
            containerStackView = .setStackView(subViews: [labelStackView,  navigationIconView], axis: .horizontal, spacing: 10, alignment: .center, distribution: .equalSpacing)
  //      }

        
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        containerStackView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 246/255, alpha: 1)
        self.contentView.addSubview(containerStackView)
                
        //containerStackView.backgroundColor = .red
        NSLayoutConstraint.activate([
            
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            navigationIconView.widthAnchor.constraint(equalToConstant: 30),
            navigationIconView.heightAnchor.constraint(equalToConstant: 30),
            
            labelStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            
            
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
                    
        ])
    }

            

}
