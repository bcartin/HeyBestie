//
//  Notifications.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/17/21.
//

import Foundation
import UIKit

extension Notification.Name {
    static let accountLoaded = Notification.Name(C_ACCOUNTLOADED)
    static let quotesLoaded = Notification.Name(C_QUOTESLOADED)
    static let verifySubscription = Notification.Name(C_VERIFYSUBSCRIPTION)
}

extension String {
func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
  let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
  let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
  let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
  let range = (self as NSString).range(of: text)
  fullString.addAttributes(boldFontAttribute, range: range)
  return fullString
}}
