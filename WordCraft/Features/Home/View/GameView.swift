//
//  GameView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 14.02.2025.
//

import UIKit
import AVFAudio
import Lottie

class GameView: UIViewController {

    var letterArray: Array<String> = []
    var wordArray: Array<String> = []
    var discoveredWords: [String: Bool] = [:]
    
    var correctAnswers: [String] = []

    var longestWord: String = ""
    
    
    var timerLabel: UILabel!
       var timer: Timer?
       var counter = 60

    
    private func setWords(){
        
    
    }

       func setupTimerLabel() {
           timerLabel = UILabel()
           timerLabel.text = "01:00"
           timerLabel.font = UIFont.boldSystemFont(ofSize: 16)
           timerLabel.textColor = .black
           timerLabel.textAlignment = .center
           timerLabel.sizeToFit()
           
           let stackView = UIStackView(arrangedSubviews: [timerLabel])
           stackView.axis = .horizontal
           stackView.alignment = .center
           stackView.backgroundColor = .white
           stackView.layer.cornerRadius = 15
           stackView.isLayoutMarginsRelativeArrangement = true
           stackView.layoutMargins = .init(top: 5, left: 5, bottom: 5, right: 5)

           let timerItem = UIBarButtonItem(customView: stackView)
           navigationItem.rightBarButtonItem = timerItem
           
       }
       
       func startTimer() {
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       }
    
    var level: Int = 0
       
       @objc func updateTimer() {
           if counter > 0 {
               counter -= 1
               let minutes = counter / 60
               let seconds = counter % 60
               timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
           } else {
               
               if correctAnswers.count == wordArray.count {
                   let vc = WonView()
                   vc.point = self.level * 10
                   navigationController?.pushViewController(vc, animated: true)
                   
               }else {
                   let vc = LostView()
                   navigationController?.pushViewController(vc, animated: true)
               }
               
               timer?.invalidate()
               timer = nil
           }
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
        
        wordCollectionView.delegate = nil
        wordCollectionView.dataSource = nil
        letterCollectionView.delegate = nil
        letterCollectionView.dataSource = nil
     
    }
    
    
    
     var bottomContainer: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
         var topContainer: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .primarypurple
         view.layer.cornerRadius = 20
         view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
         
         
        return view
    }()
    

    var gameStackView:UIStackView!
    
    let topSafeArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primarypurple
        return view
    }()
    
    lazy  var wordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width / 5, height: 45)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
             collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .primarypurple
        collectionView.tag = 1
        return collectionView
    }()
        
     var letterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
             collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 2
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        setWords()
        setupTimerLabel()
        startTimer()
        
        wordCollectionView.dataSource = self
        wordCollectionView.delegate = self
        wordCollectionView.register(WordCell.self, forCellWithReuseIdentifier: WordCell.identifier)
 
        if let layout = letterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.frame.width / 6
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
        letterCollectionView.dataSource = self
        letterCollectionView.delegate = self
        letterCollectionView.register(LetterCell.self, forCellWithReuseIdentifier: LetterCell.identifier)
  
        setUI()
        
        
        navigationItem.backBarButtonItem = nil
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action:#selector (backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        print("deinitialized")
       
    }
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    var gameLabel: UILabel!
    
    
    @objc func deleteButtonClicked(){
        
        if gameLabel.text!.count  != 1 {
            
     
             gameLabel.text?.removeLast()
        }
             
    }


    var player: AVAudioPlayer?

    func playSuccessSound() {
        if let url = Bundle.main.url(forResource: "success", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }
    }
    
    func showConfetti() {
        let confettiView = LottieAnimationView(name: "confetti")
        confettiView.frame = view.bounds
        confettiView.contentMode = .scaleAspectFill
        confettiView.loopMode = .playOnce
        view.addSubview(confettiView)
        
        confettiView.play { (finished) in
            confettiView.removeFromSuperview()
        }
    }
    
    @objc func enterButtonClicked(){
        
        let enteredText = gameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        wordArray.forEach { word in
            if discoveredWords[word] == true {
                
                print("daha önce yaptınız!")
                return
            }
            
            if enteredText == word {
                playSuccessSound()
                showConfetti()
                print("Başardın!")
                discoveredWords[word] = true
                gameLabel.text = " "
                wordCollectionView.reloadData()
                
                correctAnswers.append(enteredText)
            } else {
                print("Tekrar dene!")
            }
            
            
        }
        
    }
    
    private func setGameStackView(){
         gameLabel = .createLabel(text: " ", fontSize: 56, weight: .black)
        gameLabel.font = UIFont(name: "Delius-Regular", size: 56)
        gameLabel.textAlignment = .center
        gameLabel.backgroundColor = .red
        
        let bulbButton: UIButton = UIButton(type: .system)
        bulbButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        bulbButton.translatesAutoresizingMaskIntoConstraints = false
        bulbButton.layer.cornerRadius = 15
        bulbButton.layer.masksToBounds = true
        bulbButton.backgroundColor = UIColor(red: 227/255, green: 224/255, blue: 225/255, alpha: 1)
        bulbButton.tintColor = .black
        
      let enterButton: UIButton = UIButton(type: .system)
        enterButton.setImage(UIImage(systemName: "arrow.up.forward"), for: .normal)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.layer.cornerRadius = 15
        enterButton.layer.masksToBounds = true
        enterButton.backgroundColor = UIColor(red: 227/255, green: 224/255, blue: 225/255, alpha: 1)
        enterButton.tintColor = .black
        enterButton.addTarget(self, action: #selector(enterButtonClicked), for: .touchUpInside)
        
      let deleteButton: UIButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "delete.left"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.masksToBounds = true
        deleteButton.backgroundColor = UIColor(red: 227/255, green: 224/255, blue: 225/255, alpha: 1)
        deleteButton.tintColor = .black
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        
        
        let buttonsStackView: UIStackView = .setStackView(subViews: [bulbButton, enterButton, deleteButton], axis: .horizontal, spacing: 5, alignment: .center, distribution: .equalSpacing)
        
       
        
        gameStackView = .setStackView(subViews: [gameLabel, letterCollectionView, buttonsStackView], axis: .vertical, spacing: 0, alignment: .center, distribution: .equalSpacing)
        
        bottomContainer.addSubview(gameStackView)
        
        
        NSLayoutConstraint.activate([
            bulbButton.widthAnchor.constraint(equalToConstant: 60),
            bulbButton.heightAnchor.constraint(equalToConstant: 60),
            enterButton.widthAnchor.constraint(equalToConstant: 100),
            enterButton.heightAnchor.constraint(equalToConstant: 100),
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
           
           buttonsStackView.widthAnchor.constraint(equalTo: gameStackView.widthAnchor, multiplier: 1),
          //  buttonsStackView.heightAnchor.constraint(equalToConstant: 150),
            
            
            letterCollectionView.widthAnchor.constraint(equalTo: gameStackView.widthAnchor, multiplier: 1),
            letterCollectionView.heightAnchor.constraint(equalTo: gameStackView.heightAnchor, multiplier: 0.4),
            
            
        ])
        
    }
    
    
    private func setUI(){
        view.addSubview(bottomContainer)
        topContainer.addSubview(wordCollectionView)
        view.addSubview(topContainer)
       view.addSubview(topSafeArea)
        setGameStackView()
        
        NSLayoutConstraint.activate([
            
            
            topSafeArea.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            topSafeArea.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            topSafeArea.topAnchor.constraint(equalTo: view.topAnchor),
            topSafeArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                   
            topContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainer.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -10),
                   
            bottomContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            bottomContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            gameStackView.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.9),
            gameStackView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier:1),
            gameStackView.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            gameStackView.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            
            wordCollectionView.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.75),
            wordCollectionView.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier:1),
            wordCollectionView.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            wordCollectionView.topAnchor.constraint(equalTo: topContainer.topAnchor),
            
            
            
            
        ])
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension GameView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            

                if longestWord.count + 1 != gameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).count {
                    
                    let currentLetter = letterArray[indexPath.row]
                    gameLabel.text! += currentLetter
                }
            
                
            
            
           
            
            
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tag != 1 ?  letterArray.count : wordArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.identifier, for: indexPath) as! WordCell
            
            
            
            let word = wordArray[indexPath.row]

            if discoveredWords[word] == false {
                cell.contentView.backgroundColor = .lightGray.withAlphaComponent(0.4)
                cell.wordLabel.text = ""
                return cell
            } else {
                cell.contentView.backgroundColor = .white
                cell.wordLabel.text = word // Eğer özel bir label kullandıysan `cell.wordLabel.text = word` olmalı
                return cell
            }
     
            
        }else if collectionView.tag == 2 {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.identifier, for: indexPath) as! LetterCell
            
            cell.letterLabel.text = letterArray[indexPath.row]
            
            return cell
            
        }else {
            
        
        let cell = UICollectionViewCell()
        return cell
        }
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView.tag == 1 {
//            
//        let text = wordArray[indexPath.row]
//        
//        // Temporer bir label oluşturuyoruz
//        let label = UILabel()
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: 17) // Fontu belirleyin
//        
//        // Label boyutunu hesaplıyoruz
//        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
//        
//        // Genişliği, label'ın boyutuna göre belirliyoruz (padding ekleyebilirsiniz)
//        return CGSize(width: labelSize.width + 20, height: 40) // Yükseklik sabit
//    }
//        else {
//            return .init()
//        }
//    }
    
    
}
