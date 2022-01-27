//
//  UserManager.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import Foundation
import Firebase

class UserManager {
    
    let db = Firestore.firestore()
    
    var userListener: ListenerRegistration?
    
    func saveUserData(user: User?) {
        if let uid = user?.id {
            do {
                _ = try db.collection(C_USERS).document(uid).setData(from: user, merge: true)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveUserData(user: User?, completion: @escaping(Result<String, Error>) -> ()) {
        if let uid = user?.id {
            do {
                _ = try db.collection(C_USERS).document(uid).setData(from: user, merge: true)
                completion(.success("Saved"))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func saveUserData(data: [String:Any], completion: @escaping(Result<String, Error>) -> ()) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection(C_USERS).document(uid).setData(data, merge: true) { error in
                if let err = error {
                    completion(.failure(err))
                }
                else {
                    completion(.success(uid))
                }
            }
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(Result<User, Error>) -> ()) {
        db.collection(C_USERS).document(uid).getDocument { snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
                return
            }
            if snapshot?.exists ?? true {
                do {
                    if let user = try snapshot?.data(as: User.self) {
                        completion(.success(user))
                    }
                }
                catch {
                    completion(.failure(error))
                }
            }
            else {
                completion(.failure(CustomError.notFound))
            }
        }
    }
    
}
