//
//  HomeController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/3/21.
//

import UIKit
import GTDevTools

protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}

class HomeController: UIViewController, Alertable {
    
    //MARK: - Properties
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    
    var quotes = [CDQuote]()
    
    var pageControl = UIPageControl()
    
    var menuDelegate: HomeControllerDelegate?
    
    let menuButton = UIButton(image: UIImage(systemName: "line.horizontal.3")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleMenuTapped))
    
    let favoritesButton = UIButton(image: UIImage(systemName: "star.fill")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleFavoritesTapped))
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title"), contentMode: .scaleAspectFit, size: .init(width: 120, height: 60), cornerRadius: nil)
    
    let expiredVC = ExpiredController()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        setupPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Session.shared.userIsLoggedIn() {
            showStartScreen()
        }
        else {
            verifySubscription()
        }
    }

    
    fileprivate func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(menuButton)
        menuButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 24, bottom: 0, right: 0))
        
        view.addSubview(favoritesButton)
        favoritesButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 24))
        
        view.addSubview(logoView)
        logoView.centerHorizontaly(offset: 0)
        logoView.anchorTop(anchor: safeArea.topAnchor, paddingTop: 0)
        
        
    }
    
    private func setupDelegates(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountLoadedNotification(_:)), name: .accountLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuotesLoadedNotification(_:)), name: .quotesLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVerifySubscriptionNotification(_:)), name: .verifySubscription, object: nil)
    }
    
    private func setupPageController() {
            self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            self.pageController?.dataSource = self
            self.pageController?.delegate = self
            self.pageController?.view.backgroundColor = .clear
            self.pageController?.view.frame = CGRect(x: 0, y: 100 ,width: self.view.frame.width, height: self.view.frame.height - 100)
            self.addChild(self.pageController!)
            self.view.addSubview(self.pageController!.view)
            self.pageController?.didMove(toParent: self)
    }
    
    private func setupPages() {
        if !quotes.isEmpty {
            let initialVC = PageItemController(with: quotes[0], index: currentIndex)
            pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - Handlers
    
    func showStartScreen() {
        DispatchQueue.main.async {
            let startController = LoginController()
            let navController = UINavigationController(rootViewController: startController)
            navController.modalPresentationStyle = .fullScreen
            navController.isNavigationBarHidden = true
            self.present(navController, animated: false, completion: nil)
        }
        return
    }
    
    @objc
    private func handleMenuTapped() {
        menuDelegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleFavoritesTapped() {
        CDQuoteManager.shared.fetchFavorites { [weak self] result in
            switch result {
                
            case .success(let quotes):
                let vc = FavoritesController()
                vc.favoriteQuotesArray = quotes
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self?.showAlert(title: C_ERROR, msg: error.localizedDescription)
            }
        }
    }
    
    @objc
    private func handleAccountLoadedNotification(_ notification: NSNotification) {
        guard let user = Session.shared.user else {return}
        if user.isActive ?? false {
            FBQuoteManager.shared.fetchQuotes()
        }
        else {
            let expiredVC = ExpiredController()
            self.present(expiredVC, animated: true, completion: nil)
        }
    }
    
    @objc
    private func handleVerifySubscriptionNotification(_ notification: NSNotification) {
        verifySubscription()
    }
    
    private func verifySubscription() {
        guard let user = Session.shared.user else {return}
        if user.isActive ?? false {
            expiredVC.dismiss(animated: true, completion: nil)
        }
        else {
            self.present(expiredVC, animated: true, completion: nil)
        }
    }
    
    @objc
    private func handleQuotesLoadedNotification(_ notification: NSNotification) {
        CDQuoteManager.shared.fetchQuotesFromCoreData { [weak self] result in
            switch result {
                
            case .success(let quotes):
                self?.quotes = quotes
                self?.setupPages()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension HomeController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageItemController else { return nil }
        guard var index = currentVC.index else {return nil}
        if index == 0 { return nil }
        index -= 1
        let vc = PageItemController(with: quotes[index], index: index)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? PageItemController else { return nil }
        guard var index = currentVC.index else {return nil}
        if index >= self.quotes.count - 1 { return nil }
        index += 1
        let vc = PageItemController(with: quotes[index], index: index)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.quotes.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }

}


