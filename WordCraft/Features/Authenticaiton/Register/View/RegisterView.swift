//
//  LoginView.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 18.01.2025.
//

import UIKit
import RxSwift
import RxCocoa



class RegisterView: UIViewController, UIGestureRecognizerDelegate {

    let keyboardHandler: KeyboardHandler = KeyboardHandler()
    private let viewModel: RegisterViewModel = RegisterViewModel()
    var disposeBag: DisposeBag = DisposeBag()

    private func cleanUp() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        disposeBag = DisposeBag()

        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        emailTextField.delegate = nil
        usernameTextField.delegate = nil
        passwordTextField.delegate = nil
        
      
        if let gestures = usernameLabel.gestureRecognizers {
            for gesture in gestures {
                usernameLabel.removeGestureRecognizer(gesture)
            }
        }
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
        if let gestures = alreadyHaveAnAccountLabel.gestureRecognizers {
            for gesture in gestures {
                alreadyHaveAnAccountLabel.removeGestureRecognizer(gesture)
            }
        }
    }
    
    private var registerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "registerImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    private var emailTextField: UITextField!
    private var usernameTextField: UITextField!
    private var passwordTextField: UITextField!
        
    private var emailLabel: UILabel!
    private var usernameLabel: UILabel!
    private var passwordLabel: UILabel!
    
    private var registerLabel: UILabel!
    private var registerContentLabel: UILabel!
    
    private var alreadyHaveAnAccountLabel: UILabel!
    
    private var emailStackView: UIStackView!
    private var usernameStackView: UIStackView!
    private var passwordStackView: UIStackView!
    
   
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
        
        
    }()
    
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("SIGN UP", for: UIControl.State.normal)
        
        button.layer.cornerRadius = 10
   
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.titleLabel?.textColor = .white
        
        
        
        button
            .addTarget(
                self,
                action: #selector(registerButtonClicked),
                for: .touchUpInside
            )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.filled()
          configuration.title = title
        configuration.baseBackgroundColor = .primarypurple
          configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
          
          button.configuration = configuration
        

        button.backgroundColor = UIColor.primaryColor
        button.tintColor = .white
       
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        return button
    }()
    
    
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
        })
        viewModel.errorMessage.observe(on: MainScheduler.instance).subscribe (onNext: { [weak self] error in
            guard let self = self else { return }
            let okButton = UIAlertAction(title: "OK", style: .destructive)
            
            self.showAlertWithActions(title: "ERROR",message: error, actions: [okButton])
            
        })
        
        viewModel.registerSuccess.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] success in
            guard let self = self else { return }
            
            if success == true {
                cleanUp()
              

                
                
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = CustomTabBarController()
                    sceneDelegate.window?.makeKeyAndVisible()
                }
                
              //    let tabbar = CustomTabBarController()
               // tabbar.modalPresentationStyle = .fullScreen
               
//                self.present(tabbar, animated: true) {
//                    self.navigationController?.viewControllers.removeAll()
//                    self.navigationController?.dismiss(animated: false)
//                }

                

            }else {
                    print("error")
            }

        }).disposed(by: disposeBag)
    }
    deinit {
        print("deinitialized register view")
    }
    
    @objc func registerButtonClicked() {
        
        print("register button clicked")
        
        let emailInput = emailTextField.text!
        let usernameInput = usernameTextField.text!
        let passwordInput = passwordTextField.text!
        
        let user = RegisterUserRequest(email: emailInput, username: usernameInput, password: passwordInput)
        
        viewModel.registerUser(userRequest: user)
     
        
        
        
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.hidesBackButton = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))

       self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true



        
        
        bindViewModel()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDisppear(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        setUI()
        createDissmissKeyboardTapGesture()
        
    }
    
    func createDissmissKeyboardTapGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dissmissKeyboard(){
        keyboardHandler.dismissKeyboard(viewController: self)
    }
       
    @objc func keyboardAppear(_ notification: NSNotification){
        keyboardHandler.keyboardAppear(viewController: self, scrollView: scrollView)
    }
      
    @objc func keyboardDisppear(_ notification: NSNotification){
        keyboardHandler.keyboardDisappear(viewController: self, scrollView: scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
               
        usernameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
       scrollView.isScrollEnabled = false
    }

 
    private func setupSubviews() {
        let subviews = [
            registerImageView,
          
            registerLabel,
            registerContentLabel,
            registerButton,
            alreadyHaveAnAccountLabel,
            emailStackView,
            usernameStackView,
            passwordStackView
        ]
        subviews.forEach { scrollView.addSubview($0!) }
        view.addSubview(scrollView)
    }
    
    @objc func alreadyHaveAnAccountLabelClicked(){
        print("contact us label")
        
        navigationController?.pushViewController(LoginView(), animated: true)

    }
    
    @objc func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
   
        
    @objc func emailLabelClicked(){
        print("emaillabelclicked us label")
        emailTextField.becomeFirstResponder()
    }
    @objc func usernameLabelClicked(){
        print("usernameLabelClicked us label")
        usernameTextField.becomeFirstResponder()
    }
    
    @objc func passwordLabelClicked(){
        print("passwordLabelClicked us label")
        passwordTextField.becomeFirstResponder()
    }
    
    
    
    private func setUI(){
        view.backgroundColor = .white

        
        registerLabel = UILabel.createLabel(
            text: "Register",
            fontSize: 24,
            weight: .black,
            textColor: .primarypurple
        )
        registerContentLabel = UILabel.createLabel(
            text: "Please enter the details below to continue.",
            fontSize: 12,
            textColor: .darkGray
        )
     
        emailTextField = UITextField.createTextField(
            placeholder: "Your Email",
            inputIcon: UIImage(systemName: "envelope.fill")!,
            iconClicked: #selector(self.iconClicked(sender:)),
            viewController: self
        )     
        usernameTextField = UITextField.createTextField(
            placeholder: "Your Username",
            inputIcon: UIImage(systemName: "person.fill")!,
            iconClicked: #selector(self.iconClicked(sender:)),
            viewController: self
        )
        passwordTextField = UITextField.createTextField(
            placeholder: "Your Password",
            inputIcon: UIImage(systemName: "eye.slash.fill")!,
            iconClicked: #selector(self.iconClicked(sender:)),
            viewController: self
        )
        passwordTextField.disableAutoFill()
     
        //email
        emailLabel = UILabel.createLabel(
            text: "Email",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
        )
        emailLabel.isUserInteractionEnabled = true
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelClicked))
        emailLabel.addGestureRecognizer(emailTapGesture)
        
        //username
        usernameLabel = UILabel.createLabel(
            text: "Username",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
        )
        
        usernameLabel.isUserInteractionEnabled = true
        let userTapGesture = UITapGestureRecognizer(target: self, action: #selector(usernameLabelClicked))
        usernameLabel.addGestureRecognizer(userTapGesture)
        
        
        //password
        passwordLabel = UILabel.createLabel(
            text: "Password",
            fontSize: 12,
            weight: .bold,
            textColor: .primarypurple
            
        )
        passwordLabel.isUserInteractionEnabled = true
        let passwordTapGesture = UITapGestureRecognizer(target: self, action: #selector(passwordLabelClicked))
        passwordLabel.addGestureRecognizer(passwordTapGesture)
        //end
        
        emailStackView = UIStackView.createFormFieldStackView(
            [emailLabel, emailTextField]
        )
        usernameStackView = UIStackView.createFormFieldStackView(
            [usernameLabel, usernameTextField]
        )
        passwordStackView = UIStackView.createFormFieldStackView(
            [passwordLabel, passwordTextField]
        )
        
        alreadyHaveAnAccountLabel = UILabel.createLabel(text: "Already have an account? ", fontSize: 14)
        alreadyHaveAnAccountLabel.numberOfLines = 0
        alreadyHaveAnAccountLabel.attributedText = NSAttributedString.createAttributedString(
            normalText: "Already have an account? ",
            boldText: "Login",
            boldFontSize: CGFloat(14),
            normalColor: .darkGray,
            boldColor: .primarypurple
        )
        alreadyHaveAnAccountLabel.isUserInteractionEnabled = true
        let alreadyAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(alreadyHaveAnAccountLabelClicked))
        alreadyHaveAnAccountLabel.addGestureRecognizer(alreadyAccountTapGesture)
        

        scrollView.contentInsetAdjustmentBehavior = .never
        
      
            
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
        //                 stackView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20)
        //             ])
  
        setupSubviews()
        
        NSLayoutConstraint.activate(
[
    
    
    scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
    scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
    
    registerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.size.height * 0.06),
         registerImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         registerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
         
         registerLabel.topAnchor.constraint(equalTo: registerImageView.bottomAnchor, constant: 20),
         registerLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
         registerContentLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20),
         registerContentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
    emailStackView.topAnchor.constraint(equalTo: registerContentLabel.bottomAnchor, constant: 20),
    emailStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
    emailStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
         
         usernameStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
         usernameStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         usernameStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
         
         passwordStackView.topAnchor.constraint(equalTo: usernameStackView.bottomAnchor, constant: 20),
         passwordStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         passwordStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
         
         registerButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 35),
         registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         registerButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3),
         
    alreadyHaveAnAccountLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 25),
    alreadyHaveAnAccountLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
         
       
    alreadyHaveAnAccountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
  
            
            

            //            goToLoginPageButton.topAnchor.constraint(equalTo: goToRegisterPageButton.bottomAnchor, constant: 20),
            //            goToLoginPageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            //            goToLoginPageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            //            goToLoginPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.size.height*0.2),
            //
        
]
        )
    }
    
    @objc func iconClicked(sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            if imageView.image == UIImage(systemName: "eye.fill") {
                       // Şu anki resim "eye" ise
                passwordTextField.isSecureTextEntry = true
                       imageView.image = UIImage(systemName: "eye.slash.fill")
                       print("Changed to eye.slash")
            } else if imageView.image == UIImage(systemName: "eye.slash.fill") {
                       // Şu anki resim başka bir şeyse (örneğin "eye.slash")
                       imageView.image = UIImage(systemName: "eye.fill")
                       print("Changed to eye")
                passwordTextField.isSecureTextEntry = false
                   }
        }
    }
  
    
 
  

}



extension RegisterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // Dismiss the keyboard for the last textField
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // Swipe hareketine izin ver
    }
}
