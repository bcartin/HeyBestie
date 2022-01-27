//
//  TutorialController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import UIKit

protocol TutorialControllerDelegate {
    func didTapStart()
}

class TutorialController: UIPageViewController {
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title"), contentMode: .scaleAspectFit, size: .init(width: 200, height: 100), cornerRadius: nil)
    
    var screenText = ["Welcome To Hey Bestie. Your new best friend that will tell you what you need to hear, when you need to hear it.", "Each day, I’ll send you notifications with lifestyle tips & hacks that will help you become your very best self.", "You can also opt in to recurring notifications like meditation and skin care routine reminders. Other segmented tips are on the way as well!", "Are you ready to start our journey together?"]

    var pageControl = UIPageControl()
    
    var tutorialDelegate: TutorialControllerDelegate?
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "LightPink")
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 4.0, height: 7.0)
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont().Poppins(type: .Bold)
        button.setTitleColor(.white, for: .normal)
        button.setSizeAnchors(height: 44, width: 248)
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "LightPink")
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 4.0, height: 7.0)
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont().Poppins(type: .Bold)
        button.setTitleColor(.white, for: .normal)
        button.setSizeAnchors(height: 44, width: 248)
        return button
    }()
    
    
    init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        setupUI()

        self.setupIntro(text: screenText)
        
        
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoView)
        logoView.centerHorizontaly(offset: 0)
        logoView.anchorTop(anchor: safeArea.topAnchor, paddingTop: 64)
        
        nextButton.addTarget(self, action: #selector(handleNextTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(handleCloseTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.centerHorizontaly(offset: 0)
        nextButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
        
        startButton.isHidden = true
        view.addSubview(startButton)
        startButton.centerHorizontaly(offset: 0)
        startButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
    }
    
    private func setupIntro(text: [String]) {
                
        let vc = TutorialItemController()
        vc.screenLabel.attributedText = text[0].withBoldText(text: "Hey Bestie", font: UIFont().Poppins(size: 22))
        vc.index = 0
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func viewControllerAtIndex(index: Int) -> TutorialItemController? {
        
        if (screenText.count == 0) || (index >= screenText.count) {
            return nil
        }
        let vc = TutorialItemController()
        vc.screenLabel.attributedText = screenText[index].withBoldText(text: "Hey Bestie", font: UIFont().Poppins(size: 22))
        if index == 3 {
            nextButton.setTitle("Start", for: .normal)
        }
        else {
            nextButton.setTitle("Next", for: .normal)
        }
        vc.index = index
        return vc
    }
    
    fileprivate func indexOfViewController(viewController: TutorialItemController) -> Int {
        if let index: Int = viewController.index {
            return index
        } else {
            return NSNotFound
        }
    }
    
    
    @objc
    fileprivate func gotToLoginScreen() {
        tutorialDelegate?.didTapStart()
    }
    
    @objc
    fileprivate func handleCloseTapped() {
        tutorialDelegate?.didTapStart()
    }
    
    @objc
    fileprivate func handleNextTapped() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        
        if let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController)  {
            setViewControllers([nextViewController], direction: .forward, animated: true) { [weak self](completed) in
                
                let index = self!.indexOfViewController(viewController: nextViewController as! TutorialItemController)
                self?.startButton.isHidden = !(index > 2)
                self?.nextButton.isHidden = !(index < 3)
            }
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
        else { handleCloseTapped() }
    }


}

extension TutorialController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController: viewController as! TutorialItemController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController: viewController as! TutorialItemController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! TutorialItemController
        let index = indexOfViewController(viewController: pageContentViewController)
        self.pageControl.currentPage = index
        
        startButton.isHidden = !(index > 2)
        nextButton.isHidden = !(index < 3)
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        


    }

}
