//
//  AboutController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/27/21.
//

import UIKit

class AboutController: UIViewController {
    
    //MARK: - Properties
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title"), contentMode: .scaleAspectFit, size: .init(width: 120, height: 60), cornerRadius: nil)
    
    let backButton = UIButton(image: UIImage(systemName: "xmark.circle")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleBackTapped))
    
    let screenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont().Poppins(size: 22)
        label.textAlignment = .center
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
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
        
        view.addSubview(logoView)
        logoView.centerHorizontaly(offset: 0)
        logoView.anchorTop(anchor: safeArea.topAnchor, paddingTop: 12)
        
        view.addSubview(screenLabel)
        screenLabel.centerVertically(offset: -48)
        screenLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 48))
        
        let attributedText = NSMutableAttributedString(string: "Hey Bestie", attributes: [NSAttributedString.Key.font:UIFont().Poppins(type: .Bold, size: 22)])
        attributedText.append(NSMutableAttributedString(string: " sends you daily notifications on all things lifestyle, goal-setting, and self-improvement to help you become your very best self, one day at a time. It’s the friend that’s there to pick you up when you’re down and send you the harsh truths about life, right on time.", attributes: [NSAttributedString.Key.font:UIFont().Poppins(type: .Regular, size: 22)]))
        
        screenLabel.attributedText = attributedText
    }
    
    fileprivate func setupDelegates(){
        
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


