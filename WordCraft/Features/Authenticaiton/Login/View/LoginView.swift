//
//  LoginView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 18.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

class LoginView: UIViewController, UIGestureRecognizerDelegate {

    private var loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loggin")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
        
    private var emailLabel: UILabel!
    private var passwordLabel: UILabel!
    
    private var loginLabel: UILabel!
    private var loginContentLabel: UILabel!
    
    private var contactUsLabel: UILabel!
    private var createAccountLabel: UILabel!
    
    private var emailStackView: UIStackView!
    private var passwordStackView: UIStackView!
    
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
   
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return scrollView
        
        
    }()
    
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("LOGIN", for: UIControl.State.normal)
        
        button.layer.cornerRadius = 10
   
        
        button.titleLabel?.font = UIFont.systemFont(ofSize:12, weight: .bold)
        button.titleLabel?.textColor = .white
        
        
        
        button
            .addTarget(
                self,
                action: #selector(loginButtonClicked),
                for: .touchUpInside
            )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
       
        configuration.baseBackgroundColor = .primarypurple
          configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
          button.configuration = configuration
        

        button.backgroundColor = UIColor.primarypurple
        button.tintColor = .white
       
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        return button
    }()
    
    private func cleanUp() {
        // Klavye observerlarını kaldır
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        // DisposeBag’i sıfırla (RxSwift bağımlılıklarını temizler)
        disposeBag = DisposeBag()

        // Gesture recognizer'ları kaldır
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        emailTextField.delegate = nil
        passwordTextField.delegate = nil
        
 
        if let gestures = emailLabel.gestureRecognizers {
            for gesture in gestures {
                emailLabel.removeGestureRecognizer(gesture)
            }
        }
        if let gestures = passwordLabel.gestureRecognizers {
            for gesture in gestures {
                passwordLabel.removeGestureRecognizer(gesture)
            }
        }
        if let gestures = createAccountLabel.gestureRecognizers {
            for gesture in gestures {
                createAccountLabel.removeGestureRecognizer(gesture)
            }
        }
    }
    
    deinit {
        print("login dei nit")
    }
    
    func bindViewModel(){
        
        let loadingView = LoadingView()

        viewModel.isLoading.observe(on: MainScheduler.instance).subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            
            if isLoading {
                loadingView.show(in: self.view)
                navigationController?.navigationBar.isHidden = true
                
            }else {
                loadingView.hide()
                navigationController?.navigationBar.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        
        
        viewModel.errorMessage.observe(on: MainScheduler.instance).subscribe(onNext:{ [weak self] error in
            guard let self = self else { return }
            
            let okButton = UIAlertAction(title: "OK", style: .destructive)
            
            self.showAlertWithActions(title: "OK", message: error, actions: [okButton])
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        viewModel.loginSuccess.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] success in
            
            guard let self = self else { return }
            if success {
                
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = CustomTabBarController()
                    sceneDelegate.window?.makeKeyAndVisible()
                }
                
            }else {
                print("error")
            }
            
            
            
            
        }).disposed(by: disposeBag)
    
    }
    
    
    @objc func loginButtonClicked() {
        print("login button clicked")
 
        
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let user = LoginUserRequest(email: email, password: password)
        
        viewModel.loginUser(userRequest: user)
        
        
        
        
        
        
        
        
        
        
//        if let navigationController = self.navigationController {
//            print("Navigation Stack:")
//
//            for (index, viewController) in navigationController.viewControllers.enumerated() {
//                print("Index \(index): \(viewController)")
//            }
//        } else {
//            print("Bu view controller bir UINavigationController içinde değil.")
//        }
//        
      
    //    CustomTabBarController.presentTabBarController(from: self)
        //navigationController?.setViewControllers([customTabBarController], animated: true)
        
//        guard let window = UIApplication.shared.windows.first else { return }
//               window.rootViewController = tabBarController
//               window.makeKeyAndVisible()
      
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//           
//            sceneDelegate.switchToTabBarController()
//           }
//        if let navigationController = self.navigationController {
//            print("Navigation Stack:")
//
//            for (index, viewController) in navigationController.viewControllers.enumerated() {
//                print("Index \(index): \(viewController)")
//            }
//        } else {
//            print("Bu view controller bir UINavigationController içinde değil.")
//        }
      //  self.present(customTabBarController, animated: true)
    }
    
    

    private func createAttributedString(normalText: String, boldText: String, boldFontSize: CGFloat, normalColor: UIColor, boldColor: UIColor) -> NSAttributedString {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: normalColor
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: boldFontSize),
            .foregroundColor: boldColor,
            
        ]
            
        let attributedString = NSMutableAttributedString(
            string: normalText,
            attributes: normalAttributes
        )
        attributedString
            .append(
                NSAttributedString(string: boldText, attributes: boldAttributes)
            )
            
        return attributedString
    }
    
    @objc func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        
        
        self.navigationItem.hidesBackButton = true

        // Özel geri butonu ekle
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))

        // Swipe geri hareketini aktif et
       self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

//          navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
//                                                             style: .plain,
//                                                             target: self,
//                                                             action: #selector(backToRoot))

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        setUI()
    }
    override func viewDidLayoutSubviews() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
               
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
       scrollView.isScrollEnabled = false
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
            view.frame.origin.y -= 200
            self.scrollView.contentSize = CGSize(width: self.viewWidth, height: scrollView.frame.height + 100)
            isExpand = true
        }
    }
    @objc func keyboardDisappear(){
        // Reset the view's origin to the initial position (0,0)
          // self.scrollView.contentSize = CGSize(width: self.viewWidth, height: scrollView.frame.height - 100)
            isExpand = false
        
       // scrollView.isScrollEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y = 0
        }
    }
    

    
    private func setupSubviews() {
        let subviews = [
            loginImageView,
          
            loginLabel,
            loginContentLabel,
            loginButton,
            contactUsLabel,
            createAccountLabel,
            emailStackView,
            passwordStackView
        ]
        subviews.forEach { scrollView.addSubview($0!) }
        view.addSubview(scrollView)
    }
    
    @objc func contactUsLabelClicked(){
        print("contact us label")
    }
    
    @objc func createAccountLabelClicked(){
        print("createAccountLabelClicked us label")
        navigationController?.pushViewController(RegisterView(), animated: true)
    }

 
    
        
    @objc func emailLabelClicked(){
        print("emailTextField us label")
        emailTextField.becomeFirstResponder()
    }
    
    @objc func passwordLabelClicked(){
        print("passwordLabelClicked us label")
        passwordTextField
            .becomeFirstResponder()
    }
            
    @objc func mailIconClicked(){
        print("mailIconClicked us label")
    }
    
    @objc func eyeIconClicked(){
        print("eyeIconClicked us label")
       
    }
    
    
    
    
    private func setUI(){
        view.backgroundColor = .white

        
        loginLabel = UILabel.createLabel(
            text: "Login",
            fontSize: 24,
            weight: .black,
            textColor: .primarypurple
        )
        loginContentLabel = UILabel.createLabel(
            text: "Please enter the details below to continue.",
            fontSize: 12,
            textColor: .darkGray
        )
        emailTextField = .createTextField(
            placeholder: "Your Email", inputIcon: UIImage(systemName: "envelope.fill")!, iconClicked: #selector(mailIconClicked), viewController: self
        )
        passwordTextField = .createTextField(
            placeholder: "Your Password", inputIcon: UIImage(systemName: "eye.slash.fill")!, iconClicked: #selector(eyeIconClicked(sender:)), viewController: self
        )
 
        
     
        emailLabel = UILabel.createLabel(
            text: "Email",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
        )
        emailLabel.isUserInteractionEnabled = true
        let userTapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelClicked))
        emailLabel.addGestureRecognizer(userTapGesture)
        
        passwordLabel = UILabel.createLabel(
            text: "Password",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
            
        )
        passwordLabel.isUserInteractionEnabled = true
        let passwordTapGesture = UITapGestureRecognizer(target: self, action: #selector(passwordLabelClicked))
        passwordLabel.addGestureRecognizer(passwordTapGesture)
        
        
        emailStackView = UIStackView.createFormFieldStackView(
            [emailLabel, emailTextField]
        )
        passwordStackView = UIStackView.createFormFieldStackView(
            [passwordLabel, passwordTextField]
        )
        
        contactUsLabel = UILabel.createLabel(text: "Having issues? ", fontSize: 14)
        contactUsLabel.numberOfLines = 0
        contactUsLabel.attributedText = createAttributedString(
            normalText: "Having issues? ",
            boldText: "Contact Us",
            boldFontSize: CGFloat(14),
            normalColor: .darkGray,
            boldColor: .primarypurple
        )
        contactUsLabel.isUserInteractionEnabled = true
        let contactTapGesture = UITapGestureRecognizer(target: self, action: #selector(contactUsLabelClicked))
        contactUsLabel.addGestureRecognizer(contactTapGesture)
        
        createAccountLabel = UILabel.createLabel(text: "New Here? ", fontSize: 14)
        createAccountLabel.numberOfLines = 0
        createAccountLabel.attributedText = createAttributedString(
            normalText: "New Here? ",
            boldText: "Create Account",
            boldFontSize: CGFloat(14),
            normalColor: .darkGray,
            boldColor: .primarypurple
        )
        scrollView.contentInsetAdjustmentBehavior = .never
        
        createAccountLabel.isUserInteractionEnabled = true
        let createAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountLabelClicked))
        createAccountLabel.addGestureRecognizer(createAccountTapGesture)
            
        // Stack view to arrange labels vertically
        //            let stackView = UIStackView(arrangedSubviews: [contactUsLabel, createAccountLabel])
        //            stackView.axis = .vertical
        //            stackView.spacing = 10
        //            stackView.alignment = .leading
        //            
        //            stackView.translatesAutoresizingMaskIntoConstraints = false
        //            view.addSubview(stackView)
        //        NSLayoutConstraint.activate([
        //                 stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //                 stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        //             ])
  
        setupSubviews()
        
        NSLayoutConstraint.activate(
[
    
    
    scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
    scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
    
    loginImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.size.height * 0.07),
         loginImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         loginImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
         
         loginLabel.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 20),
         loginLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
         loginContentLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
         loginContentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
         emailStackView.topAnchor.constraint(equalTo: loginContentLabel.bottomAnchor, constant: 20),
         emailStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         emailStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
         
         passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
         passwordStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         passwordStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
         
         loginButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 35),
         loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         loginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3),
         
         contactUsLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
         contactUsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
         createAccountLabel.topAnchor.constraint(equalTo: contactUsLabel.bottomAnchor, constant: 5),
         createAccountLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
         createAccountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
  
            
            

            //            goToLoginPageButton.topAnchor.constraint(equalTo: goToRegisterPageButton.bottomAnchor, constant: 20),
            //            goToLoginPageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            //            goToLoginPageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            //            goToLoginPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.size.height*0.2),
            //               
        
]
        )
    }
    
    @objc func eyeIconClicked(sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            if imageView.image == UIImage(systemName: "eye.fill") {
                passwordTextField.isSecureTextEntry = true
                       imageView.image = UIImage(systemName: "eye.slash.fill")
                       print("Changed to eye.slash")
            } else if imageView.image == UIImage(systemName: "eye.slash.fill") {
                       imageView.image = UIImage(systemName: "eye.fill")
                       print("Changed to eye")
                passwordTextField.isSecureTextEntry = false
                   }
        }
    }
  
    

}



extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder() 
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
