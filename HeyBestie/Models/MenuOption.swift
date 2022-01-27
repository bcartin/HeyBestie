//
//  MenuOption.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/3/21.
//

import UIKit

struct MenuGroup {
    
    let groupName: String
    let options: [MenuOption]
    
}

enum MenuOption: Int, CustomStringConvertible {
    
    case About
    case Account
    case Shop
    case Settings
    case Privacy
    case Contact
    case Logout
    
    var description: String {
        switch self {
            
        case .About:
            return "About"
        case .Account:
            return "Account"
        case .Shop:
            return "Shop The Bougie Brand"
        case .Settings:
            return "Settings"
        case .Privacy:
            return "Privacy Policy"
        case .Contact:
            return "Contact Us"
        case .Logout:
            return "Logout"
        }
    }
    
    var number: Int {
        switch self {
            
        case .About:
            return 0
        case .Account:
            return 1
        case .Shop:
            return 2
        case .Settings:
            return 3
        case .Privacy:
            return 4
        case .Contact:
            return 5
        case .Logout:
            return 6
        }
    }
    
}

