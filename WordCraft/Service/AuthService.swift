//
//  AuthService.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.02.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared: AuthService = AuthService()
    private let db = Firestore.firestore()
    
    private init(){
        
    }
    
    
    static func saveUserToLocal(_ user: UserModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "cachedUser")
        }
    }
    
    static func loadUserFromLocal() -> UserModel? {
        if let savedData = UserDefaults.standard.data(forKey: "cachedUser") {
            let decoder = JSONDecoder()
            return try? decoder.decode(UserModel.self, from: savedData)
        }
        return nil
    }
    
    
    
    func registerUser(
        with userRequest: RegisterUserRequest,
        completion: @escaping (Bool, Error?) -> Void
    ){
        
        let email = userRequest.email.lowercased()
        let username = userRequest.username.lowercased()
        let password = userRequest.password
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("values can not be empty. please try again")
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Values can not be empty. please try again"]))
            
            return
        }
        var rank: Int = 0
        Task {
            do {
                let querySnapshot = try await  db.collection("users").getDocuments()
                for document in querySnapshot.documents {
                    if   let username2 = document.get("username") as? String {
                        
                        if username == username2 {
                            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "username is already using. Try again!"]))
                            return
                        }
                        
                        
                
                    }
                    
                    
                    
                }
            } catch {
                print("Error getting documents: \(error)")
                completion(false,  error)
            }
            
            Auth
                .auth()
                .createUser(withEmail: email, password: password) {
                    result,
                    error in
                    
                    if let error {
                        //UIAlertController.addAction(self)
                        print(error.localizedDescription)
                        completion(false, error)
                        return
                    }
                    
                    if let resultUser = result?.user {
                    
                        
                        self.db
                            .collection("users")
                            .document(resultUser.uid)
                            .setData(
                                ["username": username, "email": email, "point": 0, "completedLevel": 0 ]
                            ) { error in
                                if let error {
                                    
                                    completion(false, error)
                                    return
                                }
                                
                                completion(true, nil)
                                return
                            }
                        
                    } else {
                        
                        completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "can not access db. try again!"]))
                        
                        return
                    }
                    
                }
            
            
            
        }
        
    }
    
    func loginUser(with userRequest: LoginUserRequest,
                   completion: @escaping (Bool, Error?) -> Void)
    {
    
        let email = userRequest.email.lowercased()
        let password = userRequest.password
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("values can not be empty. please try again")
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Values can not be empty. please try again"]))
            
            return
        }
        
        
        Auth.auth().signIn(withEmail: email,password: password) {[weak self] result, error in
            guard let strongSelf = self else { return }
            
            if let error {
                completion(false, error)
                return
            }
            
            
            if let result {
                completion(true, nil)
                return
            }else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Auth is null. Try again!"]))
              return
            }
            
            
            
        }
        
    }
    
}
