//
//  IAPManager.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 10/22/21.
//

import Foundation
import Qonversion
import CloudKit

class IAPManager {
    static let shared = IAPManager()
    
    private init() {}
    
    func configure(completion: @escaping (Bool) -> Void) {
        //TODO: implement uid
        
        
        Qonversion.launch(withKey: "wv2hLn8EAgymHI5J1X7Tr9u1xVV613t0") { result, error in
            if let err = error {
                print(err)
                completion(false)
                return
            }
            print("ID: \(result.uid)")
            completion(true)
        }
    }
    
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        Qonversion.checkPermissions { permissions, error in
            print("Permissions: \(permissions)")
            if let subscription: Qonversion.Permission = permissions["HeyBestieSubscription"], subscription.isActive {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
    
    func purchase(completion: @escaping (Bool) -> Void) {
        Qonversion.purchase("subscription") { result, error, canceled in
            print(result)
            guard error == nil else {
                completion(false)
                return
            }
            if canceled {
                //purchase canceled
                completion(false)
            }
            else {
               // purchase completed
                Qonversion.setUserID(Session.shared.user?.id ?? "")
                
                completion(true)
                
            }
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        Qonversion.restore { results, error in
            guard error ==  nil else {
                completion(false)
                return
            }
            print(results)
        }
    }
}
