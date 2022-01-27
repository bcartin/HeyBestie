//
//  UIFont.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import UIKit

enum FontType {
    case Bold
    case Medium
    case Regular
    case SemiBold
    case Thin
    case Italic
}

extension UIFont {
    
    func Poppins(type: FontType = .Regular, size: CGFloat = 17) -> UIFont {
        var name = "Poppins-Regular"
        switch type {
        
        case .Bold:
            name = "Poppins-Bold"
        case .Medium:
            name = "Poppins-Medium"
        case .Regular:
            name = "Poppins-Regular"
        case .SemiBold:
            name = "Poppins-SemiBold"
        case .Thin:
            name = "Poppins-Thin"
        case .Italic:
            name = "Poppins-Italic"
        }
        guard let font =  UIFont(name: name, size: size) else {return UIFont.systemFont(ofSize: 17)}
        return font
        
    }
    
}
