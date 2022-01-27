//
//  CDQuote+CoreDataClass.swift
//  
//
//  Created by Bernie Cartin on 9/27/21.
//
//

import Foundation
import CoreData

@objc(CDQuote)
public class CDQuote: NSManagedObject {
    
    func setData(quote: FBQuote) {
        self.id = quote.id
        self.text = quote.text
        self.date = quote.date
        self.isFavorite = false
    }

}
