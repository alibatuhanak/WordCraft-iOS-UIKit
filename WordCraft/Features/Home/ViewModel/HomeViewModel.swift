//
//  HomeViewModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseAuth


class HomeViewModel {
        
//    let username: BehaviorSubject<String> = BehaviorSubject(value: "")
//    let exp: BehaviorSubject<Int> = BehaviorSubject(value: 0)
//    let rank: BehaviorSubject<Int> = BehaviorSubject(value: 0)
//    let point: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
//    let notification: BehaviorSubject<Notification> = BehaviorSubject(value: Notification(title: "hosgeldin", content: "merhaba, cok mutlu olduk.", isRead: false))
    

        
    var errorMessageForUser: PublishRelay<String> = PublishRelay()
    var errorMessageForLevel: PublishRelay<String> = PublishRelay()
    var isLoadingForUser: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isLoadingForLevels: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var user: PublishSubject<UserModel> = PublishSubject()
    var level: PublishSubject<[LevelModel]> = PublishSubject()
    
    private var db = Firestore.firestore()
    
    
    func getRankOfUser(userID: String, completion: @escaping (Int?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .order(by: "point", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                
                var rank = 1
                for document in documents {
                    if document.documentID == userID {
                        completion(rank, nil)
                        return
                    }
                    rank += 1
                }
                completion(nil, nil)
            }
    }
    
    func fetchLevels(){
        isLoadingForLevels.accept(true)
        
        Task {
            var levels: [LevelModel] = []
            
            do {
                let querySnapshot = try await  db.collection("levels").getDocuments()
                for  (index, document) in querySnapshot.documents.enumerated() {
                        
                   
                    let letters = document.get("letters") as? [String] ?? []
                    let words = document.get("words") as? [String] ?? []
                        
                    let levelModel = LevelModel(level: index+1, letters: letters, words: words)
                    
                    levels.append(levelModel)
                    
                    self.level.onNext(levels)
                    isLoadingForLevels.accept(false)
                    
                }
            } catch {
                print("Error getting documents: \(error)")
                self.errorMessageForLevel.accept(error.localizedDescription)
                isLoadingForLevels.accept(false)
            }
        }
        
        
    }
    
    
    
    func  fetchUser(){
        
        isLoadingForUser.accept(true)
        
        
        let userId = Auth.auth().currentUser?.uid
       
        guard let userId else {
            errorMessageForUser.accept("can not access userid from db. Try again!")
            return
        }
        let userRef = db.collection("users").document(userId)
        
        
        
        
        if let cachedUser = loadUserFromLocal() {
            
            getRankOfUser(userID: userRef.documentID) { rank, error
                in
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                let currentRank = rank ?? 0
                
                
                let userModel = UserModel(username: cachedUser.username, rank: currentRank, point: cachedUser.point,completedLevel: cachedUser.completedLevel,avatar: cachedUser.avatar, notifications: cachedUser.notifications)
                
                self.user.onNext(userModel)
                
                self.saveUserToLocal(userModel)
                self.isLoadingForUser.accept(false)
           
            print("localke")
              return
          }
        }
        

        
    
          Task {
            do {
                
        let document = try await userRef.getDocument()
                
                
                if document.exists {
                    
             
                    
            
                    
                    guard let data = document.data() else { return }
                    
                    
                    let username = data["username"] as? String ?? "username"
                    
                    let point = data["point"] as? Int ?? 0
                    
                    let completedLevel = data["completedLevel"] as? Int ?? 0
                    
                    let notifications = data["notifications"] as? [NotificationModel] ?? []
                    
                    let avatar = data["avatar"] as? String ?? "panda"
                    
                    getRankOfUser(userID: userRef.documentID) { rank, error
                        in
                        
                        if let error {
                            print(error.localizedDescription)
                            return
                        }
                        let currentRank = rank ?? 0
                        
                        
                        let userModel = UserModel(username: username, rank: currentRank, point: point,completedLevel: completedLevel,avatar: avatar, notifications: notifications)
                        
                        self.user.onNext(userModel)
                        
                        self.saveUserToLocal(userModel)
                        self.isLoadingForUser.accept(false)
                    }
                    
                    
                    
                
                    
                    
                    
                    
                }
            }catch{
                errorMessageForUser.accept(error.localizedDescription)
                self.isLoadingForUser.accept(false)
            }
        
        }
        
    }
    
    func saveUserToLocal(_ user: UserModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "cachedUser")
        }
    }
    
    func loadUserFromLocal() -> UserModel? {
        if let savedData = UserDefaults.standard.data(forKey: "cachedUser") {
            let decoder = JSONDecoder()
            return try? decoder.decode(UserModel.self, from: savedData)
        }
        return nil
    }
    
//    func fetchUser2() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            errorMessage.accept("Cannot access user ID from Firebase. Try again!")
//            return
//        }
//
//        let userRef = db.collection("users").document(userId)
//
//        userRef.getDocument { [weak self] (document, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                errorMessage.accept(error.localizedDescription)
//                return
//            }
//
//            if let document = document, document.exists {
//                guard let data = document.data() else { return }
//                print(data)
//                
//                let username = data["username"] as? String ?? ""
//                let rank = data["rank"] as? Int ?? 0
//                let point = data["point"] as? Int ?? 0
//
//                // Notifications verisini manuel olarak NotificationModel'e çevir
//                let notificationsData = data["notifications"] as? [[String: Any]] ?? []
//                let notifications = notificationsData.map { dict in
//                    return NotificationModel(
//                        title: dict["title"] as? String ?? "",
//                        content: dict["content"] as? String ?? "",
//                        isRead: dict["isRead"] as? Bool ?? false
//                    )
//                }
//
//                let userModel = UserModel(
//                    username: username,
//                    rank: rank,
//                    point: point,
//                    notifications: notifications
//                )
//
//                user.onNext(userModel) // Güncellenmiş veriyi yayınla
//            } else {
//                errorMessage.accept("User document does not exist.")
//            }
//        }
//    }

    
    
    
    
}
