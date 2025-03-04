//
//  ChangeUsernameView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 10.02.2025.
//

import UIKit

class EditProfileView: UIViewController {

   lazy var emailTextField: UITextField = {
       return
            .createTextField(
                placeholder: "Your Email",
                inputIcon: UIImage(systemName: "envelope.fill")!,
                iconClicked: #selector(emailIconClicked),
                viewController: self
            )
    }()
   lazy var usernameTextField: UITextField = {
       return
       
  
            .createTextField(
                placeholder: "Your Username",
                inputIcon: UIImage(systemName: "person.fill")!,
                iconClicked: #selector(usernameLabelClicked ),
                viewController: self
            )
           

    }()
  lazy var passwordTextField: UITextField = {
      let textField: UITextField =  .createTextField(
            placeholder: "Your Password",
            inputIcon: UIImage(systemName: "eye.slash.fill")!,
            iconClicked: #selector(eyeIconClicked(sender:)),
            viewController: self
        )
      
      return textField
    }()
    
    var textFieldsStackView: UIStackView!
    
   
    
     private var scrollView: UIScrollView = {
         let scrollView = UIScrollView()
         
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         
         
         return scrollView
         
         
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
   
        setUI()
    }
    override func viewDidLayoutSubviews() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = .next
        usernameTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
      // scrollView.isScrollEnabled = false
    }
    @objc func dismissKeyboard() {
        //view.frame.origin.y = 0
       // scrollView.contentInset = .zero
      //  scrollView.scrollIndicatorInsets = .zero
        
        view.endEditing(true)
    }
   var isExpand: Bool = false
    
    @objc func keyboardAppear(sender: NSNotification){
        print("keyboard appeared")
        scrollView.isScrollEnabled = true
        //scrollView.isScrollEnabled = true
//        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let currentTextField = UIResponder.currentFirst() as? UITextField else {
//            return
//        }
//
//        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
//        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
//        let textFieldBottomY = convertedTextFieldFrame.origin.y +  convertedTextFieldFrame.size.height
//
//        if textFieldBottomY > keyboardTopY {
//            let textBoxY = convertedTextFieldFrame.origin.y
//            let newFrameY = (textBoxY - keyboardTopY / 2 ) * -1
//            print(newFrameY)
//            view.frame.origin.y = newFrameY
//        }

        
       // view.frame.origin.y += 0
        if !isExpand {
            print("expand is true")
            view.frame.origin.y -= 50
            self.scrollView.contentSize = CGSize(width: self.viewWidth, height: scrollView.frame.height + 100)
           // scrollView.isScrollEnabled = true
            isExpand = true
        }
    }
    @objc func keyboardDisappear(){
        // Reset the view's origin to the initial position (0,0)
          // self.scrollView.contentSize = CGSize(width: self.viewWidth, height: scrollView.frame.height - 100)
            isExpand = false
        
       scrollView.isScrollEnabled = false
        scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y = 0
        }
    }
    
    
    lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .panda
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderWidth = 1
        iv.layer.cornerRadius = 50
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
        
        
    }()
    
    let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    lazy var  editIconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        
        
        return view
    }()
    
    
    
    lazy var changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil")!, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button
            .addTarget(
                self,
                action: #selector(oKbuttonClicked),
                for: .touchUpInside
            )
        return button
        
    }()
    
    @objc func oKbuttonClicked(){
        print("sadasd")
        let vc = ImagePickerModal()
        vc.appear(sender: self)
    }
    
    func setAvatar(){
        
        avatarView.addSubview(avatarImageView)
   //     editIconContainer.addSubview(changeImageButton)
    //    avatarView.addSubview(editIconContainer)
        
        
        NSLayoutConstraint.activate([
            
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
          
            
            avatarImageView.centerXAnchor
                .constraint(equalTo: avatarView.centerXAnchor),
            avatarImageView.centerYAnchor
                .constraint(equalTo: avatarView.centerYAnchor),
            avatarImageView.widthAnchor
                .constraint(equalTo: avatarView.widthAnchor),
            avatarImageView.heightAnchor
                .constraint(equalTo: avatarView.heightAnchor),
            
            // Edit butonu avatarın sağ alt köşesine konumlandırılıyor
//            editIconContainer.widthAnchor.constraint(equalToConstant: 35),
//            editIconContainer.heightAnchor.constraint(equalToConstant: 35),
//            editIconContainer.centerXAnchor
//                .constraint(equalTo: avatarView.trailingAnchor),
//            editIconContainer.centerYAnchor
//                .constraint(equalTo: avatarView.centerYAnchor, constant: 20),
//            
//            changeImageButton.centerXAnchor
//                .constraint(equalTo: editIconContainer.centerXAnchor),
//            changeImageButton.centerYAnchor
//                .constraint(equalTo: editIconContainer.centerYAnchor),
//            changeImageButton.widthAnchor
//                .constraint(equalTo: editIconContainer.widthAnchor),
//            changeImageButton.heightAnchor
//                .constraint(equalTo: editIconContainer.heightAnchor),
      
        ])
    }
    
    @objc func emailLabelClicked(){
        print("email us label")
        emailTextField.becomeFirstResponder()
    }
    @objc func usernameLabelClicked(){
        print("usernameLabelClicked us label")
        usernameTextField.becomeFirstResponder()
    }

    @objc func passwordLabelClicked(){
        print("passwordLabelClicked us label")
        passwordTextField
            .becomeFirstResponder()
    }
        
    @objc func personIconClicked(){
        print("personIconClicked us label")
    }
    
    @objc private func emailIconClicked(){
        
    }

    @objc func eyeIconClicked(sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            if imageView.image == UIImage(systemName: "eye.fill") {
                // Şu anki resim "eye" ise
                imageView.image = UIImage(systemName: "eye.slash.fill")
                print("Changed to eye.slash")
            } else if imageView.image == UIImage(systemName: "eye.slash.fill") {
                // Şu anki resim başka bir şeyse (örneğin "eye.slash")
                imageView.image = UIImage(systemName: "eye.fill")
                print("Changed to eye")
            }
        }
    }

    
    
    func setUI(){
        
        setAvatar()


        
        let   emailLabel: UILabel = .createLabel(
            text: "Email",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
            
        )
        emailLabel.textAlignment = .left
        emailLabel.isUserInteractionEnabled = true
        let emailTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(emailLabelClicked)
        )
        emailLabel.addGestureRecognizer(emailTapGesture)
        
        
        
        let   usernameLabel: UILabel = .createLabel(
            text: "Username",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
            
        )
        usernameLabel.textAlignment = .left
        usernameLabel.isUserInteractionEnabled = true
        let userTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(usernameLabelClicked)
        )
        usernameLabel.addGestureRecognizer(userTapGesture)
        
        let   passwordLabel: UILabel = .createLabel(
            text: "Password",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
            
        )
        passwordLabel.textAlignment = .left

        passwordLabel.isUserInteractionEnabled = true
        let passwordTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(passwordLabelClicked)
        )
        passwordLabel.addGestureRecognizer(passwordTapGesture)
        
        
        
        let emailStackView: UIStackView = .setStackView(
            subViews: [emailLabel, emailTextField],
            axis: .vertical,
            spacing: 5,
            alignment: .leading,
            distribution: .fill
        )
        
        let usernameStackView: UIStackView = .setStackView(
            subViews: [usernameLabel, usernameTextField],
            axis: .vertical,
            spacing: 5,
            alignment: .leading,
            distribution: .fill
        )
        
        let passwordStackView: UIStackView = .setStackView(
            subViews: [passwordLabel, passwordTextField],
            axis: .vertical,
            spacing: 5,
            alignment: .leading,
            distribution: .fill
        )
        
       // let button = UIButton(type: .system)
//        button.setTitle("Save", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = .white
//        button.backgroundColor = .primarypurple
//        button.layer.cornerRadius = 15
        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.baseBackgroundColor = .primarypurple
        config.baseForegroundColor = .white
        config.cornerStyle = .medium // Köşeleri yuvarlatma

        // İç kenar boşluklarını ayarla
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        
        
        textFieldsStackView =
            .setStackView(
                subViews: [
                    avatarView,
                    usernameStackView,
                    emailStackView,
                    passwordStackView,
                    button
                ],
                axis: .vertical,
                spacing: 20,
                alignment: .center,
                distribution: .fill
            )
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addSubview(textFieldsStackView)
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate(
            [
                scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
                scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
                emailTextField.widthAnchor
                    .constraint(
                        equalTo: textFieldsStackView.widthAnchor,
                        multiplier: 1
                    ),
                passwordTextField.widthAnchor
                    .constraint(
                        equalTo: textFieldsStackView.widthAnchor,
                        multiplier: 1
                    ),
                usernameTextField.widthAnchor
                    .constraint(
                        equalTo: textFieldsStackView.widthAnchor,
                        multiplier: 1
                    ),
                textFieldsStackView.widthAnchor
                    .constraint(
                        equalTo: scrollView.widthAnchor,
                        multiplier: 0.8
                    ),
                
                
                textFieldsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                textFieldsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0),
                
            ]
        )
    }



    

}
extension EditProfileView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder() // Dismiss the keyboard for the last textField
        } else {
            textField.resignFirstResponder() // Dismiss the keyboard for the last textField
        }
        return true
    }
}
