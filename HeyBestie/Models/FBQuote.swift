//
//  FBQuote.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/17/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FBQuote: Identifiable, Codable {
    @DocumentID var id = UUID().uuidString
    var text: String?
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case date
    }
}
