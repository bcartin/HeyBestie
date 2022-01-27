//
//  CDQuoteManager.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/27/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import GTDevTools
import CoreData

class CDQuoteManager {
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() { }
    
    static let shared = CDQuoteManager()
    
    func saveQuoteToCoreData(fbQuote: FBQuote) {
        
        guard let id = fbQuote.id else {return}

        if !quoteAlreadyInCoreData(id: id) {
            let cdQuote = CDQuote(context: context)
            cdQuote.setData(quote: fbQuote)

            do {
                try self.context.save()
                print("Quote saved to Core Data")
            }
            catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        else {
            print("Quote already in Core Data")
        }
    }
    
    func quoteAlreadyInCoreData(id: String) -> Bool {
        let request = CDQuote.fetchRequest() as NSFetchRequest<CDQuote>
        
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        var returnValue = false
        
        do {
            let quote = try context.fetch(request)
            if quote.count > 0 { returnValue = true}
        } catch {
            print(error.localizedDescription)
        }
        
        return returnValue
    }
    
    func fetchQuotesFromCoreData(completion: @escaping (Result<[CDQuote],Error>) -> Void) {
        let request = CDQuote.fetchRequest() as NSFetchRequest<CDQuote>
        
//        guard let account_id = Session.shared.user?.uid else {return}
//        let predicate = NSPredicate(format: "account_id == %@", account_id)
//        request.predicate = predicate
                
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
//        request.fetchLimit = 30
        
        do {
            let quotes = try context.fetch(request)
            DispatchQueue.main.async {
                completion(.success(quotes))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    
    func updateQuote(cdQuote: CDQuote, makeFavorite: Bool) {
        
        guard let id = cdQuote.id else {return}
        let request = CDQuote.fetchRequest() as NSFetchRequest<CDQuote>
        
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        do {
            let quotes = try context.fetch(request)
            let quote = quotes.first
            quote?.setValue(makeFavorite, forKey: C_ISFAVORITE)
            try! context.save()
            print("Quote Updated")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchFavorites(completion: @escaping (Result<[CDQuote],Error>) -> Void) {
        let request = CDQuote.fetchRequest() as NSFetchRequest<CDQuote>
        
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        request.predicate = predicate
                
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            let quotes = try context.fetch(request)
            DispatchQueue.main.async {
                completion(.success(quotes))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func deleteCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDQuote")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Core Data Cleared")
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
