//
//  CDQuote+CoreDataProperties.swift
//  
//
//  Created by Bernie Cartin on 9/27/21.
//
//

import Foundation
import CoreData


extension CDQuote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuote> {
        return NSFetchRequest<CDQuote>(entityName: "CDQuote")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var isFavorite: Bool

}
