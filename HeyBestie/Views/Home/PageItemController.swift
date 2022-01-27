//
//  PageItemController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/17/21.
//

import UIKit

class PageItemController: UIViewController {
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "title").withTintColor(.black), contentMode: .scaleAspectFill, size: .init(width: 88, height: 44))
    
    let favoriteButton = UIButton(image: UIImage(systemName: "star")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleFavoriteTapped))
    
    var index: Int?
    
    let screenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont().Poppins(size: 22)
        label.textAlignment = .center
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var quote: CDQuote
    
    init(with quote: CDQuote, index: Int) {
        self.quote = quote
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(screenLabel)
        screenLabel.centerVertically(offset: -48)
        screenLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 48))
        
        screenLabel.text = quote.text

        view.addSubview(logoView)
        logoView.anchor(top: screenLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        logoView.centerHorizontaly(offset: 0)
        
        view.addSubview(favoriteButton)
        favoriteButton.anchor(top: screenLabel.bottomAnchor, leading: screenLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 24, bottom: 0, right: 0))

        let imageName = quote.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc
    private func handleFavoriteTapped() {
        if quote.isFavorite {
            CDQuoteManager.shared.updateQuote(cdQuote: quote, makeFavorite: false)
            if let id = quote.id {
                FBQuoteManager.shared.removeFromFavorites(quoteId: id)
            }
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        else {
            CDQuoteManager.shared.updateQuote(cdQuote: quote, makeFavorite: true)
            if let id = quote.id {
                FBQuoteManager.shared.addToFavorites(quoteId: id)
            }
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
}
