//
//  MenuController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/3/21.
//

import UIKit

class MenuController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    
    var menuArray = [MenuOption]()
    
    let coverView = UIView(backgroundColor: UIColor(named: "DarkPink")!)
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "b3").withTintColor(.white), contentMode: .scaleAspectFill, size: .init(width: 150, height: 150))
    
    let menuTableView: UITableView = {
        let tv = UITableView()
//        tv.register(MenuHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.tableFooterView = UIView(frame: .zero)
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.backgroundColor = UIColor(named: "DarkPink")
        return tv
    }()
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        setupMenu()
    }

    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor(named: "DarkPink")
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(logoView)
        logoView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 24, bottom: 0, right: 0))
        
        view.addSubview(menuTableView)
        menuTableView.anchor(top: logoView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        view.addSubview(coverView)
        coverView.fillSuperview()
    }
    
    fileprivate func setupDelegates(){
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    fileprivate func setupMenu() {
        menuArray.append(MenuOption.About)
        menuArray.append(MenuOption.Account)
        menuArray.append(MenuOption.Shop)
        menuArray.append(MenuOption.Settings)
        menuArray.append(MenuOption.Privacy)
        menuArray.append(MenuOption.Contact)
        menuArray.append(MenuOption.Logout)
    }
    
    //MARK: - Handlers
    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return menuArray.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let menuOption = menuArray[indexPath.item]
        cell.textLabel?.text = menuOption.description
        cell.textLabel?.font = UIFont().Poppins(type: .SemiBold, size: 17)
        cell.backgroundColor = UIColor(named: "DarkPink")
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = menuTableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? MenuHeaderView
//        header?.groupNameLabel.text = menuArray[section].groupName
//        return header
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = indexPath.item //+ 1
        let option = MenuOption(rawValue: item)
        delegate?.handleMenuToggle(forMenuOption: option)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
}

