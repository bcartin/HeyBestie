//
//  ContainerController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/3/21.
//

import UIKit
import GTDevTools

class ContainerController: UIViewController {
    
    //MARK: - Properties
    
    var homeController = HomeController()
    var menuController: MenuController!
    var centerController: UIViewController!
    var tutorialContainerController: UIViewController!
    
    var isExpanded = false
    
    let grayOutView: UIButton = {
        let button = UIButton(backgroundColor: UIColor(white: 0, alpha: 0.7))
        button.addTarget(self, action: #selector(handleCloseMenu), for: .touchUpInside)
        return button
    }()
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "b3"), contentMode: .scaleAspectFit, size: .init(width: 300, height: 300), cornerRadius: nil)
    
    let coverView = UIView()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        configureHomeController()
        configureMenuController()
        
        setupScreenCover()
    }

    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor(named: "HotPink")
//        let safeArea = view.safeAreaLayoutGuide
    }
    
    fileprivate func setupDelegates(){
        
    }
    
    //MARK: - Handlers
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    fileprivate func configureHomeController() {
        homeController.menuDelegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
        view.addSubview(grayOutView)
        grayOutView.fillSuperview()
        grayOutView.alpha = 0
        
    }
    
    fileprivate func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    private func setupScreenCover() {
        coverView.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        coverView.addSubview(logoView)
        logoView.centerVertically(offset: 0)
        logoView.centerHorizontaly(offset: 0)
        
        view.addSubview(coverView)
        coverView.fillSuperview()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.coverView.removeFromSuperview()
        }
    }
    
}

extension ContainerController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        isExpanded = !isExpanded
        menuController.coverView.isHidden = !menuController.coverView.isHidden
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
    @objc
    fileprivate func handleCloseMenu() {
        handleMenuToggle(forMenuOption: nil)
    }
    
    fileprivate func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            //Show Menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                self.grayOutView.frame.origin.x = self.grayOutView.frame.width - 80
                self.grayOutView.alpha = 1
            }, completion: nil)
        }
        else {
            //Hide Menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
                self.grayOutView.frame.origin.x = 0
                self.grayOutView.alpha = 0
            }) { [weak self](_) in
                guard let menuOption = menuOption else {return}
                self?.didSelectMenuOption(menuOption: menuOption)
            }
        }
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .About:
            let vc = AboutController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            present(navController, animated: true, completion: nil)
        case .Account:
            let vc = AccountController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            present(navController, animated: true, completion: nil)
        case .Shop:
            guard let url = URL(string: "https://thebougiebrand.co/") else {return}
            UIApplication.shared.open(url)
        case .Settings:
            let vc = SettingsController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            present(navController, animated: true, completion: nil)
        case .Privacy:
            guard let url = URL(string: "https://drive.google.com/file/d/1afLLHD4Mn0yOUiC4qaJHpzqz6w87CJkG/view") else {return}
            UIApplication.shared.open(url)
        case .Contact:
            let email = "info@thebougiebrand.co"
            guard let url = URL(string: "mailto:\(email)") else {return}
            UIApplication.shared.open(url)
        case .Logout:
            Session.shared.logOut()
            homeController.showStartScreen()
        }
    }
}
