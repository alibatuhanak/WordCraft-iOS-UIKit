//
//  ImagePickerModal.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 9.02.2025.
//

import UIKit
import FirebaseFirestore
//let images = (1...8).map { _ in UIImage(named: "panda50")! }

var images: [String: UIImage] = [
    "panda": UIImage(named: "panda")!,
    "bird": UIImage(named: "bird")!,
    "butterfly": UIImage(named: "butterfly")!,
    "fish": UIImage(named: "fish")!,
    "jaguar": UIImage(named: "jaguar")!,
    "pelican": UIImage(named: "pelican")!,
    "turtle": UIImage(named: "turtle")!,
    "elephant": UIImage(named: "elephant")!
]


class ImagePickerModal: UIViewController {
    let db = Firestore.firestore()
    var containerStackView: UIStackView!
    
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    deinit {
        print("deinited")
    }
    
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .primarypurple
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(oKbuttonClicked), for: .touchUpInside)
        return button
  
        
    }()
    
    @objc func oKbuttonClicked(){
        print("sadasd")
       
        self.hide()
    }
    
    lazy var avatarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width/6, height: view.frame.width/6)
        
        
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ImagePickerCell.self, forCellWithReuseIdentifier: ImagePickerCell.identifier)
        cv.backgroundColor = .primarypurple
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var completionHandler: ((String) -> Void)?
    
    let avatarImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .panda
        return iv
    }()
    
    func configView(){
        view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.containerStackView.alpha = 0
    }
    
    func appear(sender: UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
        
    }
          
    private func show(){
        UIView.animate(withDuration: 0.5, delay: 0.1) {
            self.backView.alpha = 1
            self.containerStackView.alpha = 1
        }
    }
        
     func hide(){
         UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.containerStackView.alpha = 0
         } completion: { _ in
             self.dismiss(animated: true)
             self.removeFromParent()
         }
    }
    
    private func setUI(){
        let label: UILabel = .createLabel(text: "Select your avatar", fontSize: 22, weight: .bold, textColor: .white)
        
        
        containerStackView = .setStackView(subViews: [label, avatarCollectionView, self.button], axis: .vertical, spacing: 14, alignment: .center, distribution: .fill)
        
        containerStackView.layer.cornerRadius = 15
        containerStackView.layer.masksToBounds = true
        containerStackView.isLayoutMarginsRelativeArrangement = true
        
        containerStackView.layoutMargins = .init(top: 15, left: 0, bottom: 5, right: 0)
        
        view.addSubview(containerStackView)
        view.addSubview(backView)
        containerStackView.backgroundColor = .white
        view.bringSubviewToFront(containerStackView)
        configView()
        containerStackView.backgroundColor = .primarypurple
        
        NSLayoutConstraint.activate([
            
//            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            
            avatarCollectionView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.8),
            
            
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
            containerStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            containerStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        
            
            
            
            
        ])
        
    }



}
import FirebaseAuth

extension ImagePickerModal: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentImage = Array(images)[indexPath.row]
        avatarImage.image! = currentImage.value
        print("asdas")
        guard   let currentUser = AuthService.loadUserFromLocal() else {
            return
        }
        print(currentUser)
        let auth = Auth.auth().currentUser!
        
        let user = UserModel(username: currentUser.username, rank: currentUser.rank, point: currentUser.point, completedLevel: currentUser.completedLevel, avatar: currentImage.key, notifications: [])
        
        AuthService.saveUserToLocal(user)
        
        
        db.collection("users").document(auth.uid).setData(["avatar": currentImage.key], merge: true) { error in
            if let error {
                print(error.localizedDescription)
            } else {
                print("Avatar başarıyla güncellendi!")
            }
        }
        
        completionHandler?(currentImage.key)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.identifier, for: indexPath) as? ImagePickerCell else {
            fatalError("err")
        }
        let currentImage = Array(images)[indexPath.row]
        cell.avatarImageView.image = currentImage.value
        
        return cell
    }
    
    
    
}
