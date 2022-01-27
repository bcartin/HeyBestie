//
//  TutorialItemController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import UIKit

class TutorialItemController: UIViewController {
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    var index: Int?

    
    let screenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont().Poppins(size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        view.addSubview(screenLabel)
        screenLabel.centerVertically(offset: -60)
        screenLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 48))


    }
}
