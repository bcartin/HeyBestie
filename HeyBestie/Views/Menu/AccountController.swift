//
//  AccountController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/28/21.
//

import UIKit
import GTDevTools
import FirebaseAuth

class AccountController: UIViewController, Alertable {
    
    //MARK: - Properties
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let backButton = UIButton(image: UIImage(systemName: "xmark.circle")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleBackTapped))
    
    let titleLabel = UILabel(text: "ACCOUNT", font: UIFont().Poppins(type: .SemiBold, size: 22), textColor: .black, textAlignment: .center, numberOfLines: 1)
    
    let emailLabel: UILabel = {
        let label = UILabel()
        let attText = NSMutableAttributedString(string: "email: ", attributes: [NSAttributedString.Key.font:UIFont().Poppins(type: .Regular, size: 14), NSAttributedString.Key.foregroundColor:UIColor.black])
        attText.append(NSAttributedString(string: Session.shared.user?.email?.lowercased() ?? "", attributes: [NSAttributedString.Key.font:UIFont().Poppins(type: .Regular, size: 20), NSAttributedString.Key.foregroundColor:UIColor.white]))
        label.attributedText = attText
        return label
    }()
    
    let changePasswordButton = UIButton(title: "Change Password", titleColor: .white, font: UIFont().Poppins(type: .Regular, size: 17), size: nil, backgroundColor: .clear, target: self, action: #selector(handleChangePasswordTapped))
    
    let currentPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Current Password", font: UIFont().Poppins(size: 18), backgroundColor: UIColor(white: 1, alpha: 0.6), borderColor: nil, keyboardType: .default, isSecureText: true)
        tf.setSizeAnchors(height: 40, width: nil)
        tf.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6), NSAttributedString.Key.font:UIFont().Poppins(size:18)])
        tf.textColor = .black
        return tf
    }()
    
    let newPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "New Password", font: UIFont().Poppins(size: 18), backgroundColor: UIColor(white: 1, alpha: 0.6), borderColor: nil, keyboardType: .default, isSecureText: true)
        tf.setSizeAnchors(height: 40, width: nil)
        tf.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6), NSAttributedString.Key.font:UIFont().Poppins(size:18)])
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
    
    let saveButton = UIButton(title: "Save", titleColor: .white, font: UIFont().Poppins(type: .Bold), size: nil, backgroundColor: .clear, target: self, action: #selector(handleSaveButtonTapped))
    
    let cancelButton = UIButton(title: "Cancel", titleColor: .white, font: UIFont().Poppins(size: 12), size: nil, backgroundColor: .clear, target: self, action: #selector(handleCancelTapped))
    
    lazy var changePasswordView: UIView = {
        let view = UIView(frame: CGRect(origin: .init(x: 48, y: view.frame.height), size: .init(width: view.frame.width - 96, height: 300)))
        view.backgroundColor = UIColor(named: "DarkPink")!
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        let sv = UIStackView(arrangedSubviews: [currentPasswordTextField, newPasswordTextField, confirmPasswordTextField, saveButton, cancelButton])
        sv.axis = .vertical
        sv.spacing = 16
        view.addSubview(sv)
        sv.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 24, bottom: 0, right: 24))
        return view
    }()
    
    
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
    }

    
    fileprivate func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backButton)
        backButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 24, bottom: 0, right: 0))
        
        view.addSubview(titleLabel)
        titleLabel.centerHorizontaly(offset: 0)
        titleLabel.anchorTop(anchor: safeArea.topAnchor, paddingTop: 12)
        
        view.addSubview(emailLabel)
        emailLabel.centerHorizontaly(offset: 0)
        emailLabel.anchorTop(anchor: titleLabel.bottomAnchor, paddingTop: 48)
        
        view.addSubview(changePasswordButton)
        changePasswordButton.centerHorizontaly(offset: 0)
        changePasswordButton.anchorTop(anchor: emailLabel.bottomAnchor, paddingTop: 32)
        
        view.addSubview(changePasswordView)
    }
    
    fileprivate func setupDelegates(){
        
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleChangePasswordTapped() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [UIView.AnimationOptions.curveEaseInOut]) { [weak self] in
            self?.changePasswordView.frame.origin.y = (self!.view.frame.height / 4) //- 250
        }
    }
    
    @objc
    private func handleSaveButtonTapped() {
        if newPasswordTextField.text != confirmPasswordTextField.text, newPasswordTextField.text?.count ?? 0 > 0 {
            showAlert(title: C_ERROR, msg: "Passwords don't match")
            return
        }
        if let email = Session.shared.user?.email {
            if let password = currentPasswordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self](result, error) in
                    if let err = error {
                        self?.showAlert(title: C_ERROR, msg: err.localizedDescription)
                        return
                    }
                    guard let newPassword = self?.newPasswordTextField.text else {return}
                    Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { [weak self](error) in
                        if let err = error {
                            self?.showAlert(title: C_ERROR, msg: err.localizedDescription)
                            return
                        }
                        UIView.animate(withDuration: 0.4, delay: 0, options: [UIView.AnimationOptions.curveEaseInOut]) {
                            self?.changePasswordView.frame.origin.y = self?.view.frame.height ?? .zero
                        } completion: { _ in
                            self?.currentPasswordTextField.text = nil
                            self?.newPasswordTextField.text = nil
                            self?.confirmPasswordTextField.text = nil
                            self?.showMessage(message: "Password Updated", center: self?.view.center)
                        }

                    })
                }
            }
            
        }
    }
    
    @objc
    private func handleCancelTapped() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [UIView.AnimationOptions.curveEaseInOut]) { [weak self] in
            self?.changePasswordView.frame.origin.y = self?.view.frame.height ?? .zero
        } completion: { [weak self] _ in
            self?.currentPasswordTextField.text = nil
            self?.newPasswordTextField.text = nil
            self?.confirmPasswordTextField.text = nil
        }
    }
}


