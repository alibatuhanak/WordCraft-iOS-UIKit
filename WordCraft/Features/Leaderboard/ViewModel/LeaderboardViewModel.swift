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

class LeaderboardViewModel {
    
    
    var users: PublishSubject<[LeaderboardModel]> = PublishSubject()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    
    let db = Firestore.firestore()
    
    func fetchUsers(){
        isLoading.accept(true)
        var userArray: [LeaderboardModel] = []
        Task{
            
            let usersDocuments = try await db.collection("users").order(by: "point", descending: true).getDocuments()
        
            usersDocuments.documents.forEach{ document in
                
                if !document.exists {
                    return
                }
                guard let username = document.get("username") as? String else {
                    return
                }
                guard let point = document.get("point") as? Int else {
                    return
                }
                guard let image = document.get("avatar") as? String else {
                    return
                }
            
                let ledaerboardModel = LeaderboardModel(username: username, point: point, image: image)
                
                userArray.append(ledaerboardModel)

            }
        
            users.onNext(userArray)
            
            isLoading.accept(false)
        
        }
        
    }
    
    
    
    
    
    
}
