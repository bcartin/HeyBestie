//
//  ExpiredController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 12/6/21.
//

import UIKit
import GTDevTools

class ExpiredController: UIViewController, Alertable {
    
    //MARK: - Properties
    
    let headerLabel = UILabel(text: "Your subscription is inactive or has expired. Click on Subscribe to restart your subscription for $1.99 a month.", font: UIFont().Poppins(type: .SemiBold, size: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
    
    let subscribeButton: UIButton = {
        let button = UIButton(title: "SUBSCRIBE", titleColor: .white, font: UIFont().Poppins(type: .Medium, size: 18), size: nil, backgroundColor: UIColor(named: "LightPink")!, target: self, action: #selector(handleSubscribeTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        return button
    }()
    
    let subheaderLabel = UILabel(text: "If you're signing in on a new device click below to restore your subscription.", font: UIFont().Poppins(type: .SemiBold, size: 13), textColor: .white, textAlignment: .center, numberOfLines: 0)
    
    let restoreButton: UIButton = {
        let button = UIButton(title: "RESTORE", titleColor: .white, font: UIFont().Poppins(type: .Medium, size: 18), size: nil, backgroundColor: UIColor(named: "LightPink")!, target: self, action: #selector(handleRestoreTapped), cornerRadius: 0)
        button.setSizeAnchors(height: 40, width: nil)
        return button
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        self.isModalInPresentation = true
    }

    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor(named: "DarkPink")
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(headerLabel)
        headerLabel.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 180, left: 24, bottom: 0, right: 24))
        
        view.addSubview(subscribeButton)
        subscribeButton.anchor(top: headerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 48, left: 48, bottom: 0, right: 48))
        
        view.addSubview(subheaderLabel)
        subheaderLabel.anchor(top: subscribeButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 96, left: 24, bottom: 0, right: 24))
        
        view.addSubview(restoreButton)
        restoreButton.anchor(top: subheaderLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 48, left: 48, bottom: 0, right: 48))
    }
    
    fileprivate func setupDelegates(){
        
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleSubscribeTapped() {
        
        IAPManager.shared.purchase { [weak self] success in
            if success {
                UserManager().saveUserData(data: [C_ISACTIVE:true]) { result in
                    switch result {
                        
                    case .success(_):
                        Session.shared.user?.isActive = true
                        Session.shared.notifyUserLoaded()
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                    }
                }
            }
            else {
                self?.showAlert(title: C_ERROR, msg: "There was an error restarting your subscription.")
            }
        }
    }
    
    @objc
    private func handleRestoreTapped() {
        IAPManager.shared.purchase { [weak self] success in
            if success {
                UserManager().saveUserData(data: [C_ISACTIVE:true]) { result in
                    switch result {
                        
                    case .success(_):
                        Session.shared.user?.isActive = true
                        Session.shared.notifyUserLoaded()
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
                    }
                }
            }
            else {
                self?.showAlert(title: C_ERROR, msg: "There was an error restoring your subscription.m")
            }
        }
    }
    
}


