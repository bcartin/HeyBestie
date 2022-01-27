//
//  LoginController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/7/21.
//

import UIKit
import GTDevTools

class LoginController: UIViewController, Alertable {
    
    //MARK: - Properties
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title"), contentMode: .scaleAspectFit, size: .init(width: 200, height: 100), cornerRadius: nil)
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email", font: UIFont().Poppins(size: 18), backgroundColor: UIColor(white: 1, alpha: 0.6), borderColor: nil, keyboardType: .default, isSecureText: false)
        tf.setSizeAnchors(height: 40, width: nil)
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6), NSAttributedString.Key.font:UIFont().Poppins(size:18)])
        tf.textColor = .black
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password", font: UIFont().Poppins(size: 18), backgroundColor: UIColor(white: 1, alpha: 0.6), borderColor: nil, keyboardType: .default, isSecureText: true)
        tf.setSizeAnchors(height: 40, width: nil)
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6), NSAttributedString.Key.font:UIFont().Poppins(size:18)])
        tf.textColor = .black
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(title: "LOGIN", titleColor: .white, font: UIFont().Poppins(type: .Medium, size: 18), size: nil, backgroundColor: UIColor(named: "LightPink")!, target: self, action: #selector(handleLoginTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        return button
    }()
    
    let forgorPasswordButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Forgot Password", attributes: [NSAttributedString.Key.font:UIFont().Poppins(size:16), NSAttributedString.Key.foregroundColor:UIColor.white]), for: .normal)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(title: "SignUp", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 18), size: nil, backgroundColor: .clear, target: self, action: #selector(handleSignUpTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        let title = NSMutableAttributedString(string: "Don't have an Account? ", attributes: [NSAttributedString.Key.font: UIFont().Poppins(size: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        title.append(NSMutableAttributedString(string: " SIGN UP", attributes: [NSAttributedString.Key.font: UIFont().Poppins(type: .Bold, size: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
    }

    override func viewDidAppear(_ animated: Bool) {
        loginUser()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoView)
        logoView.centerHorizontaly(offset: 0)
        logoView.anchorTop(anchor: safeArea.topAnchor, paddingTop: 64)
        
        let textStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgorPasswordButton])
        textStack.axis = .vertical
        textStack.spacing = 18
        
        view.addSubview(textStack)
        textStack.centerVertically(offset: -64)
        textStack.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 48))
        
        view.addSubview(signupButton)
        signupButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 24, right: 48))
    }
    
    fileprivate func setupDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleLoginTapped() {
        if validateData() {
            guard let email = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            Session.shared.signIn(with: email, password: password) { [weak self] result in
                switch result {
                    
                case .success(let isActive):
                    if isActive {
                        // FB user subscription is active
                        IAPManager.shared.checkPermissions { hasPermission in
                            if hasPermission {
                                // App Store subscription is active.
                                self?.loginUser()
                            }
                            else {
                                // App store subscription is inactive. Update FB user.
                                UserManager().saveUserData(data: [C_ISACTIVE:false]) { result in
                                    switch result {
                                        
                                    case .success(_):
                                        Session.shared.user?.isActive = false
                                        self?.loginUser()
                                    case .failure(let error):
                                        self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                    else {
                        self?.loginUser()
                    }
                case .failure(let error):
                    self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                }
            }
        }
    }
    
    @objc
    private func handleSignUpTapped() {
        let vc = SignUpController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginUser() {
        if Session.shared.userIsLoggedIn() {
            if Session.shared.user == nil {
                shouldPresentLoadingView(true)
                UserManager().fetchUser(uid: Session.shared.uid ?? "") { [weak self] result in
                    self?.shouldPresentLoadingView(false)
                    switch result {
                    
                    case .success(let user):
                        Session.shared.user = user
                        Session.shared.notifyUserLoaded()
                        NotificationCenter.default.post(name: .verifySubscription, object: nil, userInfo: nil)
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                    }
                }
            }
            else {
                NotificationCenter.default.post(name: .verifySubscription, object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func validateData() -> Bool {
        if emailTextField.text == nil || emailTextField.text?.isEmpty ?? true {
            self.showAlert(title: C_ERROR, msg: "Email cannot be empty")
            return false
        }
        else if passwordTextField.text == nil || passwordTextField.text?.isEmpty ?? true  {
            self.showAlert(title: C_ERROR, msg: "Password cannot be empty")
            return false
        }
        return true
    }
}


