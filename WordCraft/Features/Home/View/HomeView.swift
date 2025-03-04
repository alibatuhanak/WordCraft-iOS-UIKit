//
//  HomeView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class HomeView: UIViewController {
   //var rankLabel : UILabel!
  //  var pointLabel : UILabel!
   // var badgeLabel : UILabel = UILabel()
    var text : String!
    var disposeBag = DisposeBag()
    
    
    var levelArray: [LevelModel] = []
    
    var completedLevel: Int = 0
    
    private func callViewModel(){
        
        
//        let letters = [
//            ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
//            ["k", "l", "m", "n", "o", "p", "q", "r", "s", "t"],
//            ["u", "v", "w", "x", "y", "z", "a", "e", "i", "o"],
//            ["p", "a", "i", "n", "t", "e", "d", "r", "s", "o"],
//            ["g", "r", "a", "p", "e", "s", "l", "i", "m", "n"],
//            ["c", "h", "a", "m", "p", "i", "o", "n", "s", "t"],
//            ["s", "t", "a", "r", "l", "i", "g", "h", "t", "s"],
//            ["m", "o", "u", "n", "t", "a", "i", "n", "s", "g"],
//            ["f", "l", "o", "w", "e", "r", "g", "a", "r", "d"],
//            ["b", "u", "t", "t", "e", "r", "f", "l", "y", "s"]
//        ]
//
//        let words = [
//            ["bad", "cab", "face", "hike", "idea", "jail", "kale", "made", "nice"],
//            ["lost", "malt", "name", "open", "past", "rail", "slam", "tune", "user"],
//            ["view", "waxy", "zero", "acid", "easy", "idol", "oval", "user", "zoom"],
//            ["painted", "points", "stored", "strain", "roast", "praise", "donate", "trades", "adored"],
//            ["grapes", "signal", "images", "gleams", "liable", "marine", "plains", "remains", "slogan"],
//            ["champions", "station", "motions", "machine", "inspect", "compact", "compass", "impacts", "actions"],
//            ["starlight", "straight", "alright", "targets", "lasting", "lengths", "slights", "artists", "trails"],
//            ["mountains", "stamina", "margins", "migrant", "strains", "monitor", "morains", "stowing", "taints"],
//            ["flowering", "drawings", "rewards", "forward", "growths", "grandly", "garland", "drawing", "gawking"],
//            ["butterflies", "builders", "breathers", "failures", "restful", "tumbles", "buttress", "lusters", "bustler"]
//        ]
//
//        
//        let firebaseManager = FirebaseManager()
//
//        for (index, letterSet) in letters.enumerated() {
//            let levelNumber = index + 1
//            firebaseManager.addLevel(level: levelNumber, letters: letterSet, words: words[index]) { error in
//                if let error = error {
//                    print("Level \(levelNumber) eklenirken hata oluştu: \(error.localizedDescription)")
//                } else {
//                    print("Level \(levelNumber) başarıyla eklendi!")
//                }
//            }
//        }
//        
        viewModel.fetchUser()
        viewModel.fetchLevels()
    }
    
    private func bindViewModelForLevels(){
        
        
        viewModel.errorMessageForLevel.observe(on: MainScheduler.instance).subscribe { error in
            let okButton = UIAlertAction(title: "OK", style: .destructive)
            self.showAlertWithActions(title: "ERRerewrewOR", message: error, actions: [okButton])
        }.disposed(by: disposeBag)
        
             
        let loadingView = LoadingView()

        viewModel.isLoadingForLevels.observe(on: MainScheduler.instance).subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            
            if isLoading {
                self.levelArray = [LevelModel(level: 1, letters: [], words: []),LevelModel(level: 2, letters: [], words: []),LevelModel(level: 3, letters: [], words: []),LevelModel(level: 4, letters: [], words: []),
                ]
             //   loadingView.show(in: self.view)
             //   navigationController?.navigationBar.isHidden = true
                
            }else {
                loadingView.hide()
               // navigationController?.navigationBar.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        
        
        viewModel.level.observe(on: MainScheduler.instance).subscribe (onNext:{ [weak self] levels in
            
            self?.levelArray = levels
            self?.levelsCollectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
    }
    
    private func bindViewModelForUser() {
        let loadingView = LoadingView()

        viewModel.isLoadingForUser.observe(on: MainScheduler.instance).subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            
            if isLoading {
                loadingView.show(in: self.view)
             //   navigationController?.navigationBar.isHidden = true
                
            }else {
                loadingView.hide()
               // navigationController?.navigationBar.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        
        
     
        viewModel.user.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] user in
            guard let self else{ return}
            print(31313,user)
            self.usernameLabel.text = user.username
            //self.experiencePointLabel.text = String(user.exp)
            self.rankLabel.text = "Rank \n\(user.rank)"
            
            self.pointLabel.text = "Point \n\(user.point)"
            self.avatarImageView.image = UIImage(named: user.avatar)
            
            if self.shouldReloadLevels(newLevel: user.completedLevel) {
                       self.levelsCollectionView.reloadData()
                print("yenilendi")
                   }
            self.completedLevel = user.completedLevel
            
          //  self.setbadgeLabel()
        //    self.badgeLabel.text = "\(user.notifications.count)"
        
        }).disposed(by: disposeBag)
        
        
        viewModel.errorMessageForUser.observe(on: MainScheduler.instance).subscribe { error in
            let okButton = UIAlertAction(title: "OK", style: .destructive)
            self.showAlertWithActions(title: "ERRerewrewOR", message: error, actions: [okButton])
        }.disposed(by: disposeBag)
    }
    private func shouldReloadLevels(newLevel: Int) -> Bool {
        return newLevel != completedLevel // Eğer level değişmişse güncelle
    }
//    func setbadgeLabel() {
//       var badgeLabel = UILabel()
//        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
//        badgeLabel.text = "3" // Bildirim sayısı
//        badgeLabel.textColor = .white
//        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        badgeLabel.textAlignment = .center
//
//    }
    
    private let viewModel = HomeViewModel()
    
    
    
    var levelsStackView: UIStackView!
    var challengessStackView: UIStackView!
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // Burayı değiştirerek boşluk uzunluğunu ayarlayabilirsin


        // İlk metni oluştur
        let firstText = NSAttributedString(string: "Welcome to the WordCraft 👋\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray,
            .paragraphStyle: paragraphStyle
        ])

        // NSMutableAttributedString ile başlat
        let attributedText = NSMutableAttributedString(attributedString: firstText)

        // Yeni metni ekle
        let secondText = NSAttributedString(string: "Let's continue a Game ", attributes: [
            .font: UIFont.systemFont(ofSize: 26, weight: .bold),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
            
        ])

        // İkinci metni ekle
        attributedText.append(secondText)

        // Label'a ata
        label.attributedText = attributedText
        
        return label
    }()
    
    private var userStackView: UIStackView!
    private var profileStackView: UIStackView!
    private var experienceStackView: UIStackView!
    private  var dailyTaskStackView: UIStackView!
    private var statsStackView: UIStackView!
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let containerView: UIStackView = {
        let containerView = UIStackView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.spacing = 15
        return containerView
        
//          let gradientLayer = CAGradientLayer()
//          gradientLayer.frame = view.bounds
//          gradientLayer.colors = [
//              UIColor(red: 237/255, green: 197/255, blue: 117/255, alpha: 1).cgColor,
//              UIColor.primaryColor.cgColor,
//              UIColor.primaryColor.cgColor,
//              UIColor.primaryColor.cgColor,
//              UIColor(red: 237/255, green: 197/255, blue: 117/255, alpha: 1).cgColor,
//          ]
//          gradientLayer.locations = [0.0, 0.5, 1.0] // Geçişlerin konumları
//          gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Başlangıç noktası
//          gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // Bitiş noktası
//          view.layer.addSublayer(gradientLayer)
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "panda.png")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private let usernameLabel: UILabel =  {
        let label = UILabel()
        label.text = "alibatuhanak"
        label.textColor = .black
      //  label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      
    }()
    
    private var rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Rank\n 10"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
       
        
    }()
    private  var pointLabel: UILabel = {
        let label = UILabel()
        label.text = "Point\n 10"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
        
    }()
    
    
    
    private  let gradeView: UIView =  {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 15
        
        
        let label = UILabel()
        label.text = "Expert"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        containerView.backgroundColor = UIColor(red: (255) / 255, green: (225) / 255, blue: (142) / 255, alpha: 1.0)

        
        containerView.addSubview(label)
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)])
        
        return containerView
        
        
    }()
    
    
    func updateExperiencePoint(_ xp: Int) {
        let text = "\(xp) XP"
        
        guard let attributedText = experiencePointLabel.attributedText as? NSMutableAttributedString else { return }
        
        // Sadece metni değiştir
        attributedText.replaceCharacters(in: NSRange(location: 2, length: attributedText.length - 2), with: text)
        
        experiencePointLabel.attributedText = attributedText
    }
    
    private lazy var  experiencePointLabel: UILabel = {
        let label = UILabel()
        
      //  self.text = "10 XP"
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "exp_start") // Burada istediğiniz simgeyi kullanabilirsiniz
        imageAttachment.bounds = CGRect(x: 0, y: -6, width: 24, height: 24) // Simge boyutlarını ve pozisyonunu ayarlayın
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: imageAttachment)) // Önce simgeyi ekle
        attributedString.append(NSAttributedString(string: " " + text)) // Sonra metni ekle
        
        label.attributedText = attributedString
        label.textColor = .primaryColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var notificationView: UIView = {
        // Dış yuvarlak çerçeve için bir UIView
        let biggerContainerView: UIView = UIView()
        biggerContainerView.translatesAutoresizingMaskIntoConstraints = false
      
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 25
        
        // İçindeki simge için UIImageView
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        
        // Bildirim "badge" için kırmızı daire
        let badgeView = UIView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = .red
        badgeView.layer.cornerRadius = 10 // Yuvarlak olması için yarıçapı
        badgeView.clipsToBounds = true
        
        // Badge içine bir metin eklemek için UILabel
       var badgeLabel = UILabel()
         badgeLabel.translatesAutoresizingMaskIntoConstraints = false
         badgeLabel.text = "3" // Bildirim sayısı
         badgeLabel.textColor = .white
         badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
         badgeLabel.textAlignment = .center
        
        badgeView.addSubview(badgeLabel)
        biggerContainerView.addSubview(badgeView)
        biggerContainerView.addSubview(containerView)
        badgeView.layer.zPosition = 2
        // Auto Layout ayarları
        
        NSLayoutConstraint.activate([
            // Dış çerçeve boyutu
            biggerContainerView.widthAnchor.constraint(equalToConstant: 50),
            biggerContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.widthAnchor.constraint(equalToConstant: 50),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Simge boyutu ve ortalama
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Badge boyutu ve sağ üst konumu
            badgeView.widthAnchor.constraint(equalToConstant: 20),
            badgeView.heightAnchor.constraint(equalToConstant: 20),
            badgeView.topAnchor.constraint(equalTo: biggerContainerView.topAnchor, constant: 4), // Yukarıda hafif dışarı taşma
            badgeView.trailingAnchor.constraint(equalTo: biggerContainerView.trailingAnchor, constant: 0), // Sağda hafif dışarı taşma
            
            // Badge içindeki metin merkezleme
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor)
        ])
        
        return biggerContainerView
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .primaryColor // İlerleme rengi
        
        progressView.trackTintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1) // Arka plan rengi
        
        progressView.setProgress(10/100, animated: false)
        progressView.layer.cornerRadius = 8
        progressView.layer.masksToBounds = true
        progressView.layer.borderWidth = 1
        progressView.layer.borderColor = UIColor.black.cgColor
        
        
        return progressView
    }()
    
    private lazy var levelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       layout.itemSize = CGSize(width:view.frame.size.width / 5 , height: view.frame.size.width / 5)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        
        //collectionView.collectionViewLayout.scrollDirection
        return collectionView
    }()
    
    private lazy var challengesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: view.frame.size.width - 24 , height: view.frame.size.width / 5)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
   // private var quizzesTableView: UITableView!
    
    private func setCollectionView(_ collectionView: UICollectionView, tag: Int,  _ cellClass: AnyClass?,
                                   forCellWithReuseIdentifier identifier: String){
        
        collectionView.tag = tag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass.self, forCellWithReuseIdentifier: identifier)
    }
    
    
    private func setGreetingView(){
        containerView.addArrangedSubview(greetingLabel)
        
        
        NSLayoutConstraint.activate([
            
          //  greetingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
           // greetingLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 15),
            greetingLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            
        ])
    }
    
    override func viewDidLayoutSubviews() {
     //   print(view.frame.size.width)
     //   print(scrollView.frame.size.width)
     //   print(containerView.frame.size.width)
     //   print(containerView.frame.size.width)
    }
    
    private func setStatsView(){
        let spacerView = UIView()
        spacerView.backgroundColor = .white
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        
        let spaceContainerView = UIView()
        spaceContainerView.translatesAutoresizingMaskIntoConstraints = false
        
             spaceContainerView.addSubview(spacerView)
             spaceContainerView.backgroundColor = .black
       
        
       
        let rankImageView = UIImageView(image: UIImage(named: "crown"))
        rankImageView.contentMode = .scaleAspectFit
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let rankStackView: UIStackView = .setStackView(subViews: [rankImageView, rankLabel], axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillEqually)

        rankStackView.translatesAutoresizingMaskIntoConstraints = false
   
    
         
        let pointImageView = UIImageView(image: UIImage(named: "coin"))
        pointImageView.contentMode = .scaleAspectFit
        pointImageView.translatesAutoresizingMaskIntoConstraints = false
       
        
        let pointStackView: UIStackView = .setStackView(subViews: [pointImageView, pointLabel], axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillEqually)
        pointStackView.translatesAutoresizingMaskIntoConstraints = false
   
        
        
        
        statsStackView = .setStackView(subViews: [rankStackView,spaceContainerView, pointStackView], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fill)
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.layer.cornerRadius = 15
        statsStackView.layer.borderWidth = 1
        statsStackView.layer.borderColor = UIColor.primarypurple.cgColor
        statsStackView.layer.masksToBounds = true
        statsStackView.isLayoutMarginsRelativeArrangement = true
           statsStackView.layoutMargins = UIEdgeInsets(top: 8, left: 30, bottom: 8, right: 30)

        statsStackView.backgroundColor = .primarypurple
        containerView.addArrangedSubview(statsStackView)
        NSLayoutConstraint.activate([
            
 
            spacerView.centerXAnchor.constraint(equalTo: spaceContainerView.centerXAnchor),
            spacerView.centerYAnchor.constraint(equalTo: spaceContainerView.centerYAnchor),
            
            spacerView.widthAnchor.constraint(equalToConstant: 2),
            spacerView.heightAnchor.constraint(equalTo: statsStackView.heightAnchor, multiplier: 0.65),
            
            
                   
           // statsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
           // statsStackView.topAnchor.constraint(equalTo: userStackView.bottomAnchor, constant:  15),
            statsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            
            ])
    }
    
    private func setLabel(firstText: String, secondText: String) -> UILabel {
        
        
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3// Burayı değiştirerek boşluk uzunluğunu ayarlayabilirsin


        // İlk metni oluştur
        let firstText = NSAttributedString(string: firstText, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ])

        // NSMutableAttributedString ile başlat
        let attributedText = NSMutableAttributedString(attributedString: firstText)

        // Yeni metni ekle
        let secondText = NSAttributedString(string: secondText, attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
            
        ])

        // İkinci metni ekle
        attributedText.append(secondText)

        // Label'a ata
        label.attributedText = attributedText
        
        return label
    }
    
    
    private func setDailyTaskView() {
        
        let dailyTaskImageView = UIImageView()
        dailyTaskImageView.image = UIImage(named: "daily-tasks")
        dailyTaskImageView.contentMode = .scaleAspectFit
        dailyTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
      
        let dailyTaskBackgroundImageView = UIImageView()
        dailyTaskBackgroundImageView.image = UIImage(named: "container_bg")
        dailyTaskBackgroundImageView.alpha = 0.5
        dailyTaskBackgroundImageView.contentMode = .scaleAspectFill
        dailyTaskBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        let dailyTaskImageContainer = UIView()
        dailyTaskImageContainer.translatesAutoresizingMaskIntoConstraints = false
        dailyTaskImageContainer.addSubview(dailyTaskBackgroundImageView)
        dailyTaskImageContainer.addSubview(dailyTaskImageView)
        dailyTaskImageContainer.layer.borderColor = UIColor.black.cgColor
    //    dailyTaskImageContainer.layer.borderWidth = 1
        dailyTaskImageContainer.layer.cornerRadius = 15
        dailyTaskImageContainer.layer.masksToBounds = true
        
      
       
        
        
        let dailyTaskLabel = UILabel()
        dailyTaskLabel.text = "Daily Task"
        dailyTaskLabel.textColor = .white
        dailyTaskLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        dailyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .primaryColor
        progressView.trackTintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        progressView.setProgress(3/5, animated: false)
        progressView.layer.cornerRadius = 6
        progressView.layer.masksToBounds = true
        progressView.layer.borderWidth = 1
        progressView.layer.borderColor = UIColor.black.cgColor
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let taskLabel = UILabel()
        taskLabel.text = "5 Tasks"
        taskLabel.textColor = .white
        taskLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let taskProgressLabel = UILabel()
        taskProgressLabel.text = "2/5"
        taskProgressLabel.textColor = .white
        taskProgressLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        taskProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let progressIcon = UIImageView()
        progressIcon.image = UIImage(systemName: "gift.fill")
        progressIcon.contentMode = .scaleAspectFit
        progressIcon.translatesAutoresizingMaskIntoConstraints = false
        progressIcon.tintColor = .primarypurple
        
        let progressIconContainer: UIView = UIView()
        progressIconContainer.translatesAutoresizingMaskIntoConstraints = false
        progressIconContainer.addSubview(progressIcon)
        progressIconContainer.layer.cornerRadius = 24
        progressIconContainer.tintColor = .black
        progressIconContainer.layer.borderWidth = 1
        progressIconContainer.layer.borderColor = UIColor.black.cgColor
        progressIconContainer.layer.masksToBounds = true
        progressIconContainer.backgroundColor = .white
        
        
        let taskLabelStackView: UIStackView = .setStackView(subViews: [dailyTaskLabel,taskLabel], axis: .vertical, spacing: 0, alignment: .leading, distribution: .equalCentering)
        
        let taskStackView : UIStackView = .setStackView(subViews: [taskLabelStackView,progressIconContainer], axis: .horizontal, spacing: 0, alignment: .fill, distribution: .equalCentering)
        
        
        let progressStackView: UIStackView = .setStackView(subViews: [progressView,taskProgressLabel], axis: .vertical, spacing: 0, alignment: .leading, distribution: .equalSpacing)
        
        let dailyTaskWithProgressBarStackView: UIStackView = .setStackView(subViews: [taskStackView,progressStackView], axis: .vertical, spacing: 35, alignment: .leading, distribution: .fill)
        
        let spacerView = UIView()
        let spacerView2 = UIView()
        
        dailyTaskStackView = .setStackView(subViews: [spacerView,dailyTaskImageContainer,spacerView2, dailyTaskWithProgressBarStackView], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fill)


        dailyTaskStackView.layer.borderColor = UIColor.black.cgColor
      //  dailyTaskStackView.layer.borderWidth = 1
        dailyTaskStackView.layer.cornerRadius = 15
        dailyTaskStackView.layer.masksToBounds = true
        dailyTaskStackView.backgroundColor = UIColor.primarypurple
        
        containerView.addArrangedSubview(dailyTaskStackView)
        
        NSLayoutConstraint.activate([
    
            dailyTaskWithProgressBarStackView.heightAnchor.constraint(equalTo: dailyTaskStackView.heightAnchor, constant: -30),
            
            taskStackView.trailingAnchor.constraint(equalTo: dailyTaskStackView.trailingAnchor, constant: -10),
               
            
            spacerView.widthAnchor.constraint(equalToConstant: 5),
            spacerView.heightAnchor.constraint(equalTo: dailyTaskStackView.heightAnchor),
            spacerView2.widthAnchor.constraint(equalToConstant: 5),
            spacerView2.heightAnchor.constraint(equalTo: dailyTaskStackView.heightAnchor),
            
            
            progressView.trailingAnchor.constraint(equalTo: dailyTaskStackView.trailingAnchor, constant: -10),
           progressView.heightAnchor.constraint(equalToConstant: 12),  // Yükseklik
            
            
            dailyTaskImageContainer.widthAnchor.constraint(equalToConstant: 140),
            dailyTaskImageContainer.heightAnchor.constraint(equalToConstant: 140),
            
            dailyTaskImageView.centerXAnchor.constraint(equalTo: dailyTaskImageContainer.centerXAnchor),
            dailyTaskImageView.centerYAnchor.constraint(equalTo: dailyTaskImageContainer.centerYAnchor),
            dailyTaskImageView.widthAnchor.constraint(equalToConstant: 100),
            dailyTaskImageView.heightAnchor.constraint(equalToConstant: 100),
            
           
            progressIconContainer.widthAnchor.constraint(equalToConstant: 48),
            progressIconContainer.heightAnchor.constraint(equalToConstant: 48),
       
            
            progressIcon.centerXAnchor.constraint(equalTo: progressIconContainer.centerXAnchor),
            progressIcon.centerYAnchor.constraint(equalTo: progressIconContainer.centerYAnchor),
            
            dailyTaskBackgroundImageView.centerXAnchor.constraint(equalTo: dailyTaskImageContainer.centerXAnchor),
            dailyTaskBackgroundImageView.centerYAnchor.constraint(equalTo: dailyTaskImageContainer.centerYAnchor),
            dailyTaskBackgroundImageView.widthAnchor.constraint(equalTo: dailyTaskImageContainer.widthAnchor),
            dailyTaskBackgroundImageView.heightAnchor.constraint(equalTo: dailyTaskImageContainer.heightAnchor),
            
           // dailyTaskStackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 15),
         //   dailyTaskStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dailyTaskStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            dailyTaskStackView.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    private func setUserView(){
        let spacerView = UIView()
        let spacerView2 = UIView()
        
     //   experienceStackView = .setStackView(subViews: [ usernameLabel, experiencePointLabel], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fill)
        //experienceStackView.backgroundColor = .red
      //  profileStackView = .setStackView(subViews: [ experienceStackView, progressBar], axis: .vertical, spacing: 5, alignment: .leading, distribution: .fill)
        userStackView = .setStackView(subViews: [ avatarImageView,spacerView, usernameLabel,spacerView2, notificationView], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fill)
        
        containerView.addArrangedSubview(userStackView)
        //   profileStackView.backgroundColor = .blue
        NSLayoutConstraint.activate([
            spacerView.widthAnchor.constraint(equalToConstant: 20),
            spacerView.heightAnchor.constraint(equalToConstant: 20),
            
            spacerView2.widthAnchor.constraint(equalToConstant: 20),
            spacerView2.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
  
   
    //MARK: -lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUser()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("asdasdasdas")
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelForUser()
        bindViewModelForLevels()
        callViewModel()
        
        setContainerView()
        setUI()
        
    
        
        view.backgroundColor = .white
   
        
    }
    var levelsCollectionViewHeightConstraint: NSLayoutConstraint!
    var challengesCollectionViewHeightConstraint: NSLayoutConstraint!
    var levelToggleLabel: Bool!
    var challengeToggleLabel: Bool!
    var viewAllLabel: UILabel!
    
    @objc func viewAllForLevelClicked(_ sender: UITapGestureRecognizer){
        levelToggleLabel = !levelToggleLabel
        
        if levelToggleLabel {
            if let layout = levelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
            
            
            
            levelsCollectionViewHeightConstraint.constant =  view.frame.size.width * 3 / 5 + 20
            viewAllLabel.text = "Collapse All"
          
            stackViewBottomConstraint?.isActive = false
            challengesCollectionViewHeightConstraint = challengessStackView.heightAnchor.constraint(equalToConstant: view.frame.height*2/3)
            challengesCollectionViewHeightConstraint.isActive = true
            
            levelsCollectionView.showsVerticalScrollIndicator = true
            levelsCollectionView.showsHorizontalScrollIndicator = false
            
            
        } else {
            if let layout = levelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            levelsCollectionView.showsVerticalScrollIndicator = false
            levelsCollectionView.showsHorizontalScrollIndicator = true
            levelsCollectionViewHeightConstraint.constant =  view.frame.size.width / 5
            viewAllLabel.text = "See All"
            challengesCollectionViewHeightConstraint.isActive = false
            // değişken verip yap
            stackViewBottomConstraint?.isActive = true
            
        }
        
        
        UIView.animate(withDuration: 0.5) {
                  self.view.layoutIfNeeded()
              }
        
    }    
  
    var stackViewBottomConstraint : NSLayoutConstraint!
    
    private func setChallengeSystem(){
        setCollectionView(challengesCollectionView, tag: 2, ChallengeCell.self, forCellWithReuseIdentifier: ChallengeCell.identifier)
        challengeToggleLabel = false
        var challengeLabelsStackView: UIStackView!
        
        let challengesLabel = UILabel()
        challengesLabel.text = "Challenges"
        challengesLabel.textColor = .black
        challengesLabel.textAlignment = .left
        challengesLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        challengesLabel.translatesAutoresizingMaskIntoConstraints = false
        
 
   //     let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewAllForChallengeClicked))
    //    viewAllLabel.addGestureRecognizer(recognizer)
        
        challengeLabelsStackView = .setStackView(subViews: [challengesLabel], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fillEqually)
        challengeLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        challengessStackView = .setStackView(subViews: [challengeLabelsStackView, challengesCollectionView], axis: .vertical, spacing: 10, alignment: .center, distribution: .fill)
        challengessStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addArrangedSubview(challengessStackView)
        stackViewBottomConstraint = challengessStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            stackViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            challengeLabelsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            
            challengesCollectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
   
            //challengesCollectionView.topAnchor.constraint(equalTo: challengesLabel.bottomAnchor, constant: 10),
           // challengesCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

         //   challengessStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
         //   challengessStackView.topAnchor.constraint(equalTo: levelsStackView.bottomAnchor, constant: 20),
        //    challengessStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            challengessStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
       //  challengessStackView.heightAnchor.constraint(equalToConstant: view.frame.width),

            
       
            
            
        ])
    }
    
    private func setLevelSystem(){
        setCollectionView(levelsCollectionView, tag: 1, LevelCell.self, forCellWithReuseIdentifier: LevelCell.identifier)
        levelToggleLabel = false
        var levelLabelsStackView: UIStackView!
        
        let levelsLabel = UILabel()
        levelsLabel.text = "Levels"
        levelsLabel.textColor = .black
        levelsLabel.textAlignment = .left
        levelsLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        levelsLabel.translatesAutoresizingMaskIntoConstraints = false
        
         viewAllLabel = UILabel()
        viewAllLabel.text = "See All"
        viewAllLabel.textColor = .lightGray
        viewAllLabel.textAlignment = .right
        viewAllLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        viewAllLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllLabel.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewAllForLevelClicked))
        viewAllLabel.addGestureRecognizer(recognizer)
        
        levelLabelsStackView = .setStackView(subViews: [levelsLabel, viewAllLabel], axis: .horizontal, spacing: 0, alignment: .center, distribution: .fillEqually)
        levelLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        levelsStackView = .setStackView(subViews: [levelLabelsStackView, levelsCollectionView], axis: .vertical, spacing: 10, alignment: .center, distribution: .fill)
        levelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addArrangedSubview(levelsStackView)
        
        levelsCollectionViewHeightConstraint =  levelsCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.width/5)
        levelsCollectionViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            levelLabelsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            levelsCollectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
          
            
         //1   levelsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
           //1 levelsStackView.topAnchor.constraint(equalTo: dailyTaskStackView.bottomAnchor, constant: 20),
            levelsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            //levelsStackView.heightAnchor.constraint(equalToConstant: view.frame.size.width/5 ),
        ])
        
    }
    
    private func setQuiz(){
//        kelime yolu
    }
    
    private func setContainerView(){
        view.addSubview(self.scrollView)
        scrollView.addSubview(containerView)
        
//        let hConst =   containerView.heightAnchor.constraint(equalToConstant: 2000)
//        hConst.isActive = true
//        hConst.priority = UILayoutPriority(50)
        
        
        NSLayoutConstraint.activate([
                        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
                        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
                        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                        self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0),
                        

            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // **BU ÖNEMLİ**

            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                     
            
                     
//            
//        
//            containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant:0),
//            containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -0),
//            containerView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor, constant: 0),
//            containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
//            
//            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
//            containerView.heightAnchor.constraint(equalToConstant: 1000*2),
            
//            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
//            self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
//            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0),
//            
//        
//            containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant:0),
//            containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
//            containerView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor, constant:0),
//            containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0),

         
        
            
        ])
    }
    
    private func setUI(){
        setUserView()
        setStatsView()
        setGreetingView()
        setDailyTaskView()
        setLevelSystem()
        setChallengeSystem()
      
    
   
        NSLayoutConstraint.activate([
          
           
            
            
         //   userStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
          //  userStackView.heightAnchor.constraint(equalToConstant: 50),//son eklendi
            userStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
        
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            
       //     progressBar.widthAnchor.constraint(equalTo: profileStackView.widthAnchor),
       //     progressBar.heightAnchor.constraint(equalToConstant: 16),
           
       
        //   experienceStackView.widthAnchor.constraint(equalTo: profileStackView.widthAnchor),

         
        
            
        ])
      
       
        
    }
    

}


extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 1 ? levelArray.count  : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if (levelArray[indexPath.row].level <= completedLevel + 1){
                let gameView = GameView()

                gameView.level = levelArray[indexPath.row].level
                gameView.letterArray = self.levelArray[indexPath.row].letters
                gameView.wordArray = self.levelArray[indexPath.row].words
                gameView.discoveredWords =  Dictionary(uniqueKeysWithValues: self.levelArray[indexPath.row].words.map { ($0, false) })
                gameView.longestWord = levelArray[indexPath.row].words.max(by: { $0.count < $1.count }) ?? ""
                gameView.modalPresentationStyle = .fullScreen
                navigationController?.pushViewController(gameView, animated: true)
            }
        
            
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            
        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier, for: indexPath) as? LevelCell else {
                fatalError("The tableView could not dequeue a LevelCell in View.")
            }
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .primarypurple
            cell.layer.masksToBounds = true
            //cell.levelLabel.text = "\(levelArray?[indexPath.row].level ?? indexPath.row)"
            let level = levelArray[indexPath.row].level
            cell.levelLabel.text = "\(level )"
            print(level)
            if !(level <= completedLevel + 1){
                cell.backgroundColor = .darkGray
            }else {
                cell.backgroundColor = .primarypurple
            }
            
            return cell
            
        }   else if collectionView.tag == 2{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCell.identifier, for: indexPath) as? ChallengeCell else {
                fatalError("The tableView could not dequeue a ChallengeCell in View.")
            }
            cell.layer.cornerRadius = 10
            cell.backgroundColor = UIColor(red:241/255, green: 241/255, blue: 241/255, alpha: 1)
            cell.layer.masksToBounds = true
               
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
        
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//          return CGSize(width:view.frame.size.width / 5 , height: view.frame.size.width / 5)
//      }
      
    
    
}



//let iconImage = UIImage(named: "giraffe")?.withRenderingMode(.alwaysOriginal)
//
//        let leftIcon = UIBarButtonItem(image: iconImage,
//                                       style: .plain,
//                                       target: self,
//                                       action: nil)
//   self.navigationItem.leftBarButtonItem = leftIcon // Do any additional setup after loading the view.
//        navigationController?.navigationBar.backgroundColor = .blue
//        if let navigationBar = self.navigationController?.navigationBar {
//            // Büyük bir resim için UIImageView oluştur
//            let largeIconImageView = UIImageView(image: UIImage(named: "panda"))
//            largeIconImageView.contentMode = .scaleAspectFit
//            largeIconImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44) // Boyutunu ayarla
//
//            // UIBarButtonItem içine koy
//            let largeIconBarButtonItem = UIBarButtonItem(customView: largeIconImageView)
//            navigationBar.topItem?.leftBarButtonItem = largeIconBarButtonItem
//        }
//        if let navigationBar = self.navigationController?.navigationBar {
//            let navbarHeight = navigationBar.frame.size.height
//            print("Navigation bar yüksekliği: \(navbarHeight) pt")
//        }
