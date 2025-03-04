//
//  WonViewModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 24.02.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseAuth


class  WonViewModel {
    
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid
    
    var isLoading: BehaviorRelay = BehaviorRelay(value: false)
    
    func updatePoint(newPoint: Int){
        isLoading.accept(true)
        if let savedData = UserDefaults.standard.data(forKey: "cachedUser") {
            let decoder = JSONDecoder()
            
            var user: UserModel!
            do {
                
             user = try decoder.decode(UserModel.self, from: savedData)
            } catch {
                print(error)
                return
            }
            
            guard let userId else {
                return
            }
            
            let userRef = db.collection("users").document(userId)
            
            
//            userRef.getDocument { document, error in
//                       if let document = document, document.exists {
//                           if let currentPoints = document.data()?["points"] as? Int {
//                               let newPoints = currentPoints + 10
//                               userRef.updateData(["points": newPoints]) { error in
//                                   if let error = error {
//                                       print("Error updating points: \(error.localizedDescription)")
//                                   } else {
//                                       print("Points updated successfully: \(newPoints)")
//                                   }
//                               }
//                           }
//                       } else {
//                           print("User document not found")
//                       }
//                   }
            
            
            userRef.updateData([
                "point": user.point + newPoint,
                "completedLevel": user.completedLevel + 1
                
            ]){ error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                let encoder = JSONEncoder()
                let  newUser = UserModel(username: user.username, rank: user.rank, point: user.point + newPoint, completedLevel: user.completedLevel + 1,avatar:   user.avatar, notifications: [])
                if let encoded = try? encoder.encode(newUser) {
                   
                    UserDefaults.standard.set(encoded, forKey: "cachedUser")
                }
                
                
                
                self.isLoading.accept(false)
                
                
            }
            
        }
    }
    
    
    
    
}
