//
//  SignUpController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import UIKit
import GTDevTools

class SignUpController: UIViewController, Alertable {
    
    //MARK: - Properties
    
    var tutorialContainerController: UIViewController!
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title"), contentMode: .scaleAspectFit, size: .init(width: 200, height: 100), cornerRadius: nil)
    
    let headerLabel = UILabel(text: "Subscribe today & get a 14 day free trial. Then, pay only $1.99 a month.", font: UIFont().Poppins(), textColor: .black, textAlignment: .center, numberOfLines: 0)
    
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
    
    let confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Confirm Password", font: UIFont().Poppins(size: 18), backgroundColor: UIColor(white: 1, alpha: 0.6), borderColor: nil, keyboardType: .default, isSecureText: true)
        tf.setSizeAnchors(height: 40, width: nil)
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6), NSAttributedString.Key.font:UIFont().Poppins(size:18)])
        tf.textColor = .black
        return tf
    }()
    
    let subscribeButton: UIButton = {
        let button = UIButton(title: "SUBSCRIBE", titleColor: .white, font: UIFont().Poppins(type: .Medium, size: 18), size: nil, backgroundColor: UIColor(named: "LightPink")!, target: self, action: #selector(handleSubscribeTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        return button
    }()
    
    let termsButton: UIButton = {
        let button = UIButton(title: "", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 18), size: nil, backgroundColor: .clear, target: self, action: #selector(handleTermsTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        let title = NSMutableAttributedString(string: "By clicking subscribe you agree to the \n", attributes: [NSAttributedString.Key.font: UIFont().Poppins(size: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
        title.append(NSMutableAttributedString(string: " Terms & Conditions", attributes: [NSAttributedString.Key.font: UIFont().Poppins(type: .Bold, size: 12), NSAttributedString.Key.foregroundColor: UIColor.white]))
        title.append(NSMutableAttributedString(string: " and", attributes: [NSAttributedString.Key.font: UIFont().Poppins(size: 12), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton(title: "", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 18), size: nil, backgroundColor: .clear, target: self, action: #selector(handlePrivacyTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 16, width: nil)
        let title = NSMutableAttributedString(string: "Privacy Policy", attributes: [NSAttributedString.Key.font: UIFont().Poppins(type: .Bold, size: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(title: "", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 18), size: nil, backgroundColor: .clear, target: self, action: #selector(handleLoginTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        let title = NSMutableAttributedString(string: "Have an Account? ", attributes: [NSAttributedString.Key.font: UIFont().Poppins(size: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        title.append(NSMutableAttributedString(string: " LOGIN", attributes: [NSAttributedString.Key.font: UIFont().Poppins(type: .Bold, size: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        handleShowTutorial()
        NotificationsManager.shared.authorize()
    }

    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoView)
        logoView.centerHorizontaly(offset: 0)
        logoView.anchorTop(anchor: safeArea.topAnchor, paddingTop: 64)
        
        view.addSubview(headerLabel)
        headerLabel.anchor(top: logoView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 32, left: 32, bottom: 0, right: 32))
        
        let termsStack = UIStackView(arrangedSubviews: [termsButton, privacyButton])
        termsStack.axis = .vertical
        termsStack.spacing = 0
        
        let textStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, subscribeButton, termsStack])
        textStack.axis = .vertical
        textStack.spacing = 18
        
        view.addSubview(textStack)
        textStack.anchor(top: headerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 24, left: 48, bottom: 0, right: 48))
        
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 24, right: 48))
    }
    
    fileprivate func setupDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleSubscribeTapped() {
        if validateData() {
            guard let email = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            IAPManager.shared.purchase { success in
                if success {
                    Session.shared.signUp(with: email, password: password) { [weak self] result in
                        switch result {
                            
                        case .success(_):
                            self?.navigationController?.popToRootViewController(animated: true)
                        case .failure(let error):
                            self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                        }
                    }
                }
                else {
                    print("Error")
                }
            }
        }
    }
    
    @objc
    private func handleTermsTapped() {
        guard let url = URL(string: "https://thebougiebrand.co/pages/hey-bestie-terms-conditions") else {return}
        UIApplication.shared.open(url)
    }
    
    @objc
    private func handlePrivacyTapped() {
        guard let url = URL(string: "https://drive.google.com/file/d/1afLLHD4Mn0yOUiC4qaJHpzqz6w87CJkG/view") else {return}
        UIApplication.shared.open(url)
    }
    
    @objc
    private func handleLoginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    fileprivate func handleShowTutorial() {
        let vc = TutorialController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.tutorialDelegate = self
        tutorialContainerController = UINavigationController(rootViewController: vc)
        
        
        view.addSubview(tutorialContainerController.view)
        addChild(tutorialContainerController)
        tutorialContainerController.didMove(toParent: self)
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
        else if passwordTextField.text != confirmPasswordTextField.text {
            self.showAlert(title: C_ERROR, msg: "Passwords don't match")
            return false
        }
        return true
    }
    
}

extension SignUpController: TutorialControllerDelegate {
    func didTapStart() {
        tutorialContainerController.view.removeFromSuperview()
        tutorialContainerController.removeFromParent()
    }
    
    
}


