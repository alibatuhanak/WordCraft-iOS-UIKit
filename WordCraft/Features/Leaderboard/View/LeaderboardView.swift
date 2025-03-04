//
//  LeaderboardView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 25.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

class LeaderboardView: UIViewController {

    let viewModel: LeaderboardViewModel = LeaderboardViewModel()
    var otherUsers: [LeaderboardModel] = []
    let currentUser = AuthService.loadUserFromLocal()
    
    private func callViewModel(){
        bindViewModel()
        viewModel.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchUsers()
    }
    
    
    private func bindViewModel(){
        let loadingView = LoadingView()
        
        
        viewModel.isLoading.observe(on: MainScheduler.instance).subscribe (onNext: { isLoading in
            
            if isLoading {
                loadingView.show(in: self.view)
                
            }else {
                loadingView.hide()
            }
            
        })
        
        
        viewModel.users.observe(on: MainScheduler.instance).subscribe(onNext: { users in
            
            if let firstUserUsername = self.firstUserStackView.viewWithTag(1) as? UILabel,
               let secondUserUsername = self.secondUserStackView.viewWithTag(1) as? UILabel,
               let thirdUserUsername = self.thirdUserStackView.viewWithTag(1) as? UILabel,
               
               let firstUserPoint = self.firstUserStackView.viewWithTag(2) as? UILabel,
               let secondUserPoint = self.secondUserStackView.viewWithTag(2) as? UILabel,
               let thirdUserPoint = self.thirdUserStackView.viewWithTag(2) as? UILabel,
                              
                let firstUserImage = self.firstUserStackView.viewWithTag(3) as? UIImageView,
               let secondUserImage = self.secondUserStackView.viewWithTag(3) as? UIImageView,
               let thirdUserImage = self.thirdUserStackView.viewWithTag(3) as? UIImageView {
                
                guard let currentUser = self.currentUser  else
                {
                    return
                }
                let goldColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0) // Altın sarısı renk
                   
            
                //TODO: MARK
                
                firstUserUsername.text = users[0].username
                secondUserUsername.text = users[1].username
                thirdUserUsername.text = users[2].username
                
                firstUserPoint.text = "\(users[0].point) pts"
                secondUserPoint.text = "\(users[1].point) pts"
                thirdUserPoint.text = "\(users[2].point) pts"
                                
                firstUserImage.image = UIImage(named:users[0].image)
                   secondUserImage.image = UIImage(named:users[1].image)
                   thirdUserImage.image = UIImage(named:users[2].image)
                
                if users[0].username == currentUser.username {
                    firstUserUsername.textColor = goldColor
                    firstUserPoint.textColor = goldColor
                }else {
                    firstUserUsername.textColor = .white
                    firstUserPoint.textColor = .white
                }
                
                if users[1].username == currentUser.username {
                    secondUserUsername.textColor = goldColor
                    secondUserPoint.textColor = goldColor
                }else {
                    secondUserUsername.textColor = .white
                    secondUserPoint.textColor = .white
                }
                
                if users[2].username == currentUser.username {
                    thirdUserUsername.textColor = goldColor
                    thirdUserPoint.textColor = goldColor
                }else {
                    thirdUserUsername.textColor = .white
                    thirdUserPoint.textColor = .white
                }
                
            }
            
            
            
            self.otherUsers = Array(users.dropFirst(3))
            self.bottomCollectionView.reloadData()
            
            
        })
                
        
        
    }
    
    
    
    
    
    
    let bottomLeaderboardView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.layer.cornerRadius = 35
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] 
        
        
        return bottomView
        
        
    }()
    
    let bg_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgbgbg
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
        
        
    }()   
    let bg_confetti: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "confetti")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.65
        imageView.layer.masksToBounds = true
        return imageView
        
        
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 149/255, green: 131/255, blue: 219/255, alpha: 0.95)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    let topSafeAreaView: UIView = {
        let topSafeAreaView = UIView()
        topSafeAreaView.backgroundColor =   UIColor(red: 76/255, green: 5/255, blue: 109/255, alpha: 1)
        topSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        topSafeAreaView.layer.masksToBounds = true
        return topSafeAreaView
    }()
    
    lazy var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width - 20, height: view.frame.width / 5)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       // collectionView.indicatorStyle = .black // Önce bir stil belirle
     
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LeaderboardItemCell.self, forCellWithReuseIdentifier: LeaderboardItemCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
     
        return collectionView
    }()
    
    
    var topStackView: UIStackView!
    var firstUserStackView: UIStackView!
    var secondUserStackView: UIStackView!
    var thirdUserStackView: UIStackView!
    
    
    
    private func createProfileView(username: String, usernameTag:Int = 1, point: String,pointTag: Int = 2,color: CGColor, avatarIcon: UIImage,avatarIconTag: Int = 3,crownIcon: UIImage, rank: Int) -> UIStackView {
        
        let avatarSize: CGFloat = rank == 1 ? 100 : 75
        
        
        let usernameLabel = UILabel()
        usernameLabel.text = username
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.tag = usernameTag
        
        let pointLabel = UILabel()
        pointLabel.text = point
        pointLabel.textColor = UIColor.init(red: 255/255, green: 246/255, blue: 235/255, alpha: 1)
        pointLabel.font = .systemFont(ofSize: 18, weight: .medium)
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.tag = pointTag
      
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFit
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.image = avatarIcon
        avatarImage.tag = avatarIconTag
        avatarImage.layer.borderColor = color
        avatarImage.layer.borderWidth = 5
        avatarImage.layer.cornerRadius = rank == 1 ? 50 : 37.5 // Rank 1 için büyük
        
        let crownImage = UIImageView()
        crownImage.image = crownIcon
        crownImage.contentMode = .scaleAspectFit
        crownImage.translatesAutoresizingMaskIntoConstraints = false
        
        let rankLabel = UILabel()
        rankLabel.text = String(rank)
        rankLabel.textColor = .white
        rankLabel.textAlignment = .center
        rankLabel.font = .systemFont(ofSize: 12, weight: .bold)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let badge: UIView = UIView()
        badge.backgroundColor = UIColor.red
        badge.addSubview(rankLabel)
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = UIColor(cgColor: color)
        badge.layer.cornerRadius = avatarSize / 8
        badge.layer.masksToBounds = true
        
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
      //  imageContainerView.backgroundColor = .primarypurple
        
        imageContainerView.addSubview(avatarImage)
        imageContainerView.addSubview(crownImage)
        imageContainerView.addSubview(badge)
        
        
      //  imageContainerView.backgroundColor = .blue
        
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalToConstant: avatarSize),
            imageContainerView.heightAnchor.constraint(equalToConstant: avatarSize),
            
            avatarImage.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            avatarImage.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            
            avatarImage.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            
            rankLabel.centerXAnchor.constraint(equalTo: badge.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: badge.centerYAnchor),
            
            badge.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: -10),
            badge.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            badge.heightAnchor.constraint(equalToConstant: avatarSize/4),
            badge.widthAnchor.constraint(equalToConstant: avatarSize/4),
         
            crownImage.heightAnchor.constraint(equalToConstant: avatarSize/2),
            crownImage.widthAnchor.constraint(equalToConstant: avatarSize/2),
            
            crownImage.centerXAnchor.constraint(equalTo: avatarImage.centerXAnchor),
            crownImage.bottomAnchor.constraint(equalTo: avatarImage.topAnchor, constant: avatarSize/5),
            
        ])
        
        if rank == 1 {
            rankLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return .setStackView(subViews: [imageContainerView, usernameLabel, pointLabel], axis: .vertical, spacing: 2, alignment: .center, distribution: .fill)
             }
             
        return .setStackView(subViews: [ imageContainerView, usernameLabel, pointLabel], axis: .vertical, spacing:  2, alignment: .center, distribution: .fill)
         }

        
    private func topThreeLeaders(){
        
        firstUserStackView = createProfileView(username: "loading...", point: "0 pts",color:  UIColor(red: 239/255, green: 133/255, blue: 51/255, alpha: 1).cgColor, avatarIcon: .panda50,crownIcon: .goldCrown, rank: 1)
        firstUserStackView.setCustomSpacing(20, after: firstUserStackView.arrangedSubviews[0])
        
        
      //  firstUserStackView.backgroundColor = .red
        secondUserStackView = createProfileView(username: "loading...", point: "0 pts",color: UIColor(red: 172/255, green: 189/255, blue: 202/255, alpha: 1).cgColor, avatarIcon: .panda50,crownIcon: .silverCrown, rank: 2)
        secondUserStackView.setCustomSpacing(15, after: secondUserStackView.arrangedSubviews[0])
        
     //   secondUserStackView.backgroundColor  = .yellow
        thirdUserStackView =  createProfileView(username: "loading...", point: "0 pts",color: UIColor(red: 153/255, green: 76/255, blue: 80/255, alpha: 1).cgColor, avatarIcon: .panda50,crownIcon: .bronzCrown, rank: 3)
     //   thirdUserStackView.backgroundColor = .green
        thirdUserStackView.setCustomSpacing(15, after: thirdUserStackView.arrangedSubviews[0])
        
        topStackView = .setStackView(subViews: [secondUserStackView, firstUserStackView, thirdUserStackView], axis: .horizontal, spacing: 5, alignment: .center, distribution: .fillEqually)
      //  topStackView.backgroundColor = .purple
       
        
        containerView.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            
        //    customUserStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            
            
//            
//            topStackView.leadingAnchor.constraint(equalTo: bg_imageView.leadingAnchor),
//            topStackView.trailingAnchor.constraint(equalTo: bg_imageView.trailingAnchor),
//            topStackView.topAnchor.constraint(equalTo: bg_imageView.safeAreaLayoutGuide.topAnchor, constant: 50),
//            topStackView.bottomAnchor.constraint(equalTo: bg_imageView.safeAreaLayoutGuide.bottomAnchor, constant: -80),

            topStackView.centerXAnchor.constraint(equalTo: bg_imageView.centerXAnchor),
            topStackView.centerYAnchor.constraint(equalTo: bg_imageView.centerYAnchor),
            topStackView.widthAnchor.constraint(equalTo: bg_imageView.widthAnchor),
            topStackView.heightAnchor.constraint(equalTo: bg_imageView.heightAnchor, constant: 0.7),
          
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func setUI(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        containerView.addSubview(bg_imageView)
        containerView.addSubview(bg_confetti)
        bottomLeaderboardView.addSubview(bottomCollectionView)
        containerView.addSubview(bottomLeaderboardView)
        
        view.addSubview(containerView)
      //  view.addSubview(topSafeAreaView)
      //  view.backgroundColor = UIColor(red: 154/255, green: 99/255, blue: 186/255, alpha: 1)
        topThreeLeaders()
        
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

//            topSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            topSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topSafeAreaView.topAnchor.constraint(equalTo: view.topAnchor),
//            topSafeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//
//     
            bg_imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bg_imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bg_imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bg_imageView.bottomAnchor.constraint(equalTo: bottomLeaderboardView.topAnchor),


  
            bg_confetti.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bg_confetti.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bg_confetti.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            bg_confetti.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            
            bottomLeaderboardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomLeaderboardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomLeaderboardView.topAnchor.constraint(equalTo: bg_imageView.bottomAnchor),
            bottomLeaderboardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
           bottomLeaderboardView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            bottomCollectionView.leadingAnchor.constraint(equalTo: bottomLeaderboardView.leadingAnchor, constant: 10),
            bottomCollectionView.trailingAnchor.constraint(equalTo: bottomLeaderboardView.trailingAnchor, constant: -10),
            bottomCollectionView.topAnchor.constraint(equalTo: bottomLeaderboardView.topAnchor, constant: 10),
            bottomCollectionView.bottomAnchor.constraint(equalTo: bottomLeaderboardView.bottomAnchor, constant: -10),
            
        ])
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUI()
        callViewModel()
    }
    



}



extension LeaderboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeaderboardItemCell.identifier, for: indexPath) as? LeaderboardItemCell else {
            fatalError("The tableView could not dequeue a LevelCell in View.")
        }
      //  cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.pointLabel.text = "\(otherUsers[indexPath.row].point)"
        cell.usernameLabel.text = otherUsers[indexPath.row].username
        cell.profileImageView.image = UIImage(named:otherUsers[indexPath.row].image)
        
        cell.rankLabel.text = "\(indexPath.row + 4)"
        
        if self.currentUser?.username == otherUsers[indexPath.row].username {
            cell.profileStackView.layer.borderWidth = 2
            cell.profileStackView.layer.borderColor = UIColor.systemYellow.cgColor
        }else {
            cell.profileStackView.layer.borderWidth = 0
       
        }
        
        return cell
    }
    
    
}
