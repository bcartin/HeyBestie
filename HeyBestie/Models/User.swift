//
//  User.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id = UUID().uuidString
    var email: String?
    var favorites: [String]?
    var waterReminder: Bool?
    var meditationReminder: Bool?
    var skincareReminder: Bool?
    var isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case favorites
        case waterReminder
        case meditationReminder
        case skincareReminder
        case isActive
    }
}
