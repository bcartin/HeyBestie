//
//  FavoritesController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/27/21.
//

import UIKit

class FavoritesController: UIViewController {
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let backButton = UIButton(image: UIImage(systemName: "arrow.backward.circle")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleBackTapped))
    
    let titleLabel = UILabel(text: "FAVORITES", font: UIFont().Poppins(type: .SemiBold, size: 22), textColor: .black, textAlignment: .center, numberOfLines: 1)
    
    var favoriteQuotesArray = [CDQuote]()
    
    let favoritesTableView: UITableView = {
        let tv = UITableView()
        tv.register(FavoriteCell.self, forCellReuseIdentifier: "Cell")
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView(frame: .zero)
        return tv
    }()
    
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
        
        view.addSubview(favoritesTableView)
        favoritesTableView.anchor(top: titleLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupDelegates(){
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    @objc
    private func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension FavoritesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteQuotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteCell
        cell.separatorInset.left = 0
        cell.delegate = self
        cell.configureCell(with: favoriteQuotesArray[indexPath.item])
        return cell
    }
    
    
}

extension FavoritesController: FavoriteCellProtocol {
    
    func didTapFavorite() {
        CDQuoteManager.shared.fetchFavorites { [weak self] result in
            switch result {
                
            case .success(let quotes):
                self?.favoriteQuotesArray = quotes
                self?.favoritesTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
