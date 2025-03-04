//
//  ProfileViewModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth


class ProfileViewModel {
    
    
    
    var profile: PublishSubject<ProfileModel> = PublishSubject()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    
    func fetchUser(){
        isLoading.accept(true)
        guard    let user = AuthService.loadUserFromLocal() else{
            return
        }
        
        guard let userEmail = Auth.auth().currentUser?.email else
        {
            return
        }
        
        profile.onNext(ProfileModel(username: user.username, email: userEmail , image: user.avatar))
        
        isLoading.accept(false)
        
    }
    
}
