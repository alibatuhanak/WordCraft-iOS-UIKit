import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

struct ProfileSetting {
    let title: String
    let icon: UIImage
}

let profileSettings: [ProfileSetting] = [
    ProfileSetting(title: "Edit Profile", icon: UIImage(systemName: "person.fill")!),
    ProfileSetting(title: "Sound", icon: UIImage(systemName: "speaker.fill")!),
    ProfileSetting(title: "Language Selection", icon: UIImage(systemName: "globe")!),
    ProfileSetting(title: "Delete Account", icon: UIImage(systemName: "trash.fill")!),
    ProfileSetting(title: "Quit", icon: UIImage(systemName: "rectangle.portrait.and.arrow.right")!),
]

class ProfileView: UIViewController {
    
    var userStackView: UIStackView!
    var usernameLabel: UILabel!
    var emailLabel: UILabel!
    
    let viewModel : ProfileViewModel = ProfileViewModel()
    
    private func bindViewModel(){
        
        viewModel.profile.observe(on:MainScheduler.instance).subscribe(onNext: {[weak self] profile in
            
            guard let self else{return}
            
            emailLabel.text = profile.email
            usernameLabel.text = profile.username
            avatarImageView.image = UIImage(named: profile.image)
            
            
        })
        
    }
    private func callViewModel(){
        bindViewModel()
        viewModel.fetchUser()
    }
    
    
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .panda50
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderWidth = 1
        iv.layer.cornerRadius = 50
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
        
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let user = AuthService.loadUserFromLocal()!
        
        if avatarImageView.image != UIImage(named:user.avatar){
            avatarImageView.image = UIImage(named: user.avatar)
            print("eşit değil")
        }
       
    }

    
        let backgroundImageView: UIImageView = {
            let iv = UIImageView()
            iv.image = .profileBg
            iv.contentMode = .scaleAspectFill
            iv.alpha = 0.8
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        
        
        }()
    
    let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
       let bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
           view.translatesAutoresizingMaskIntoConstraints = false
           view.layer.cornerRadius = 35
           view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] 
           
       
        return view
    }()
    
    let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "square.and.pencil")
        iv.tintColor = .black
           iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    lazy var  editIconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        
     //   let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeAvatarImage))
   //     view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    
    lazy var changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil")!, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeAvatarImage), for: .touchUpInside)
        return button
        
    }()
    
  
    
    @objc func changeAvatarImage(){
        print("clicked")
        
        let vc = ImagePickerModal()
        vc.completionHandler = { [weak self] image in
            self?.avatarImageView.image = UIImage(named: image)
            
        }
        vc.appear(sender: self)
        
        
    }
    
    lazy var  bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width-20, height: 50)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileItemCell.self, forCellWithReuseIdentifier: ProfileItemCell.identifier)
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        callViewModel()
    
    //    navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
//        let exitImage =  UIImage(systemName: "rectangle.portrait.and.arrow.right")
//        let exitButton =  UIBarButtonItem(
//            image: exitImage,
//            style: .done,
//            target: self,
//            action: nil
//        )
//        exitButton.tintColor = .white
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = exitButton
     
    }
   
    
    func setUserProfile(){
        usernameLabel = .createLabel(text: "alibatuhanak", fontSize: 20, textColor: .white)
        emailLabel = .createLabel(text: "alibatuhanak@gmail.com", fontSize: 16,textColor: .white.withAlphaComponent(0.7))
        
        bottomContainerView.backgroundColor = .white
        
        userStackView = .setStackView(subViews: [avatarView, usernameLabel, emailLabel], axis: .vertical, spacing: 1, alignment: .center, distribution: .fill)
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        userStackView.setCustomSpacing(10, after: avatarView)
    }
    
    func setCollectionView(){
        
    }
    
    
    func setUI(){
        setUserProfile()
        topContainerView.addSubview(userStackView)
      //  topContainerView.addSubview(backgroundImageView)
        
        bottomContainerView.addSubview(bottomCollectionView)
        
        view.addSubview(topContainerView)
        view.addSubview(bottomContainerView)
        view.addSubview(backgroundImageView)
        
        avatarView.addSubview(avatarImageView)
        editIconContainer.addSubview(changeImageButton)
        avatarView.addSubview(editIconContainer)
        
        view.sendSubviewToBack(backgroundImageView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            
            
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
          
            
          avatarImageView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarView.widthAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: avatarView.heightAnchor),
            
            // Edit butonu avatarın sağ alt köşesine konumlandırılıyor
            editIconContainer.widthAnchor.constraint(equalToConstant: 35),
            editIconContainer.heightAnchor.constraint(equalToConstant: 35),
            editIconContainer.centerXAnchor.constraint(equalTo: avatarView.trailingAnchor),
            editIconContainer.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 20),
           
            changeImageButton.centerXAnchor.constraint(equalTo: editIconContainer.centerXAnchor),
            changeImageButton.centerYAnchor.constraint(equalTo: editIconContainer.centerYAnchor),
            changeImageButton.widthAnchor.constraint(equalTo: editIconContainer.widthAnchor),
            changeImageButton.heightAnchor.constraint(equalTo: editIconContainer.heightAnchor),
            
            userStackView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            userStackView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            userStackView.topAnchor.constraint(equalTo: topContainerView.safeAreaLayoutGuide.topAnchor),
           
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
           
            bottomCollectionView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            bottomCollectionView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            bottomCollectionView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 15),
            bottomCollectionView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
           
            
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
     
         
            
            
        ])
    }
   
    func signOutAndRedirect() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "cachedUser")
            
           
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                
                let navigationController = UINavigationController(rootViewController: AuthenticationView())
                
                navigationController.navigationBar.tintColor = .white
                
                navigationController.navigationBar.barTintColor = .backgroundColor.withAlphaComponent(0.7)
         
                
                sceneDelegate.window?.rootViewController = navigationController
                sceneDelegate.window?.makeKeyAndVisible()
            }
            
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        //    errorMessage.onNext(error.localizedDescription)
        }
    }
}



extension ProfileView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            
            let editProfileView = EditProfileView()
            editProfileView.emailTextField.text = emailLabel.text
            editProfileView.usernameTextField.text = usernameLabel.text
            editProfileView.avatarImageView.image = avatarImageView.image
            
        navigationController?.pushViewController(editProfileView, animated: true)
        }
        if (indexPath.row == 4) {
            
            signOutAndRedirect()
        }
        
        
        
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileItemCell {
        //    cell.containerStackView.backgroundColor = UIColor.gray
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
             //   cell.containerStackView.backgroundColor = UIColor.clear // Reset to default color
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileSettings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileItemCell.identifier, for: indexPath) as? ProfileItemCell else {
            fatalError("error fatal profileitemcell")
        }
        
        cell.titleLabel.text = profileSettings[indexPath.row].title
        cell.iconImageView.image = profileSettings[indexPath.row].icon

        cell.configure(showExtraView: indexPath.item == 1)

     

        return cell
    }
    
    
}
