//
//  FBQuoteManager.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/17/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FBQuoteManager {
    
    let db = Firestore.firestore()
        
    var quotesListener: ListenerRegistration?
    
    var quotes = [FBQuote]()
    
    static let shared = FBQuoteManager()
    
    func fetchQuotes() {
        UserDefaults.standard.set(Date(timeIntervalSince1970: 20000), forKey: C_LASTUPDATED)
        let lastUpdated = UserDefaults.standard.object(forKey: C_LASTUPDATED) as? Date ?? Date(timeIntervalSince1970: 20000)
        let today = Date()
        let ref = db.collection(C_QUOTES)
        let query = ref.order(by: C_DATE, descending: true)
            .whereField(C_DATE, isLessThan: today)
            .whereField(C_DATE, isGreaterThan: lastUpdated)
        query.getDocuments(completion: { snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {
                print("No Quotes")
                return
            }
            var quotes = documents.compactMap({ (queryDocumentSnapshot) -> FBQuote? in
                return try? queryDocumentSnapshot.data(as: FBQuote.self)
            })
            quotes.sort{$0.date ?? Date() > $1.date ?? Date()}
            quotes.forEach({ fbQuote in
                CDQuoteManager.shared.saveQuoteToCoreData(fbQuote: fbQuote)
            })
            UserDefaults.standard.set(Date(), forKey: C_LASTUPDATED)
            self.notifyQuotesLoaded()
//            completion(.success(quotes))
        })
    }
    
    func notifyQuotesLoaded() {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .quotesLoaded, object: nil, userInfo: nil)
            }
    }
    
    func addToFavorites(quoteId: String) {
        guard let uid = Session.shared.user?.id else {return}
        db.collection(C_USERS).document(uid).updateData([
            C_FAVORITES: FieldValue.arrayUnion([quoteId])])
    }
    
    func removeFromFavorites(quoteId: String) {
        guard let uid = Session.shared.user?.id else {return}
        db.collection(C_USERS).document(uid).updateData([
            C_FAVORITES: FieldValue.arrayRemove([quoteId])])
    }
}
