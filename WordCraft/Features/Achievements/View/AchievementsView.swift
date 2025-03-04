//
//  HomeView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import UIKit

struct Achievement {
    let title: String
    let info: String
}

let achievements = [
    Achievement(title: "Word Master", info: "Find a total of 1000 words."),
    Achievement(title: "Marathoner", info: "Log in for 7 consecutive days and find at least one word each day."),
    Achievement(title: "Quick Thinker", info: "Find all 9 words within 30 seconds."),
    Achievement(title: "One Letter, Many Words", info: "Find 9 words that all contain the same letter."),
    Achievement(title: "All Letters Used!", info: "Use all 10 given letters to find all 9 words."),
    Achievement(title: "Beginner Level", info: "Reach level 5."),
    Achievement(title: "Word Master", info: "Reach level 10."),
    Achievement(title: "Dictionary Hunter", info: "Reach level 20."),
    Achievement(title: "Perfect Round", info: "Find all 9 words in a single round."),
    Achievement(title: "Category Expert", info: "Find all 9 words in a single round within a category."),
    Achievement(title: "Lightning Fast", info: "Find all 9 words within 20 seconds."),
    Achievement(title: "Halfway There", info: "Find at least 5 words in a round."),
    Achievement(title: "Almost Perfect", info: "Find 8 out of 9 words in a round."),
    Achievement(title: "Word Streak", info: "Find at least 1 word in 10 consecutive rounds."),
    Achievement(title: "Puzzle Solver", info: "Find all 9 words in 5 different rounds."),
    Achievement(title: "Master of Letters", info: "Find all 9 words using each letter at least once."),
    Achievement(title: "Unstoppable", info: "Find all 9 words in 10 consecutive rounds."),
    Achievement(title: "Hidden Gem", info: "Find a rare or uncommon word in a round."),
    Achievement(title: "Speed Demon", info: "Find the first 5 words within 10 seconds."),
    Achievement(title: "Ultimate Champion", info: "Find all 9 words in 50 different rounds.")
]


class AchievementsView: UIViewController {

    private var containerView: UIView = {
        let containerView = UIView()
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.translatesAutoresizingMaskIntoConstraints = false
      //  containerView.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        containerView.backgroundColor = .white
        return containerView
    }()

    lazy var badgesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width/3.5, height: view.frame.width/3)
        let spacing = 15.0
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let cv  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(AchievementItemCell.self, forCellWithReuseIdentifier: AchievementItemCell.identifier)
        cv.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.barStyle = .black
    //    navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
      //  navigationController?.navigationBar.topItem?.title = "Badges"
        navigationController?.navigationBar.barTintColor = .white
        let titleLabel = UILabel()
         titleLabel.text = "Badges"
         titleLabel.textColor = .black
         titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
         titleLabel.sizeToFit()
        
         
         self.navigationItem.titleView = titleLabel
        
        
     
        setUI()


    }
    
    
    func setUI(){
        containerView.addSubview(badgesCollectionView)
        
        view.addSubview(containerView)
        view.backgroundColor = containerView.backgroundColor
        
        NSLayoutConstraint.activate([
            
            
            badgesCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            badgesCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            badgesCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            badgesCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


extension AchievementsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementItemCell.identifier, for: indexPath) as? AchievementItemCell else {
            fatalError("achievementitemcell can not created.")
        }
        
        cell.badgeLabel.text = achievements[indexPath.row].title
        
        
        
        return cell
        
    }
    
    
}
