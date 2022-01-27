//
//  FavoriteCell.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/27/21.
//

import UIKit

protocol FavoriteCellProtocol {
    func didTapFavorite()
}

class FavoriteCell: UITableViewCell {
    
    var delegate: FavoriteCellProtocol?
    
    var quote: CDQuote?
    
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont().Poppins(size: 14)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let favoriteButton = UIButton(image: UIImage(systemName: "star.fill")!, tintColor: .white, size: .init(width: 20, height: 20))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with quote: CDQuote) {
        self.quote = quote
        quoteLabel.text = quote.text
    }
    
    fileprivate func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(quoteLabel)
        quoteLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 32))
        
        favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped), for: .touchUpInside)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.centerVertically(offset: 0)
        favoriteButton.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    @objc
    private func handleFavoriteTapped() {
        if let quote = quote {
            CDQuoteManager.shared.updateQuote(cdQuote: quote, makeFavorite: false)
            FBQuoteManager.shared.removeFromFavorites(quoteId: quote.id ?? "")
            delegate?.didTapFavorite()
        }
    }
}
