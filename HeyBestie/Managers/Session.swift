//
//  Session.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/7/21.
//

import Foundation
import Firebase

class Session {
    
    var uid = Auth.auth().currentUser?.uid
    var user: User?
    
    static let shared = Session()
    
    init() {
        if self.userIsLoggedIn() {
            self.loadUser()
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
    }
    
    func userIsLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signIn(with email: String, password: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                completion(.failure(err))
            }
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            UserManager().fetchUser(uid: user.uid) { result in
                switch result {
                
                case .success(let dbUser):
                    self.user = dbUser
                    self.notifyUserLoaded()
                    completion(.success(dbUser.isActive ?? false))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
    }
    
    func signUp(with email: String, password: String, completion: @escaping (Result<String,Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let err = error {
                completion(.failure(err))
            }
            guard let fbUser = result?.user else {
                completion(.failure(error!))
                return
            }
            let user = User(id: fbUser.uid, email: email, isActive: true)
            UserManager().saveUserData(user: user) { [weak self] result in
                switch result {
                case .success(_):
                    self?.uid = user.id
                    self?.loadUser()
                    completion(.success(user.id ?? ""))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadUser() {
        UserManager().fetchUser(uid: self.uid ?? "") { [weak self] result in
            switch result {
            
            case .success(let user):
                self?.user = user
                self?.notifyUserLoaded()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func notifyUserLoaded() {
        if let user = self.user {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .accountLoaded, object: nil, userInfo: [C_USER:user])
            }
        }
    }
    
}
