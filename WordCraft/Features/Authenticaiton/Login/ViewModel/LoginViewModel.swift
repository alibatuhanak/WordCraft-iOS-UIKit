//
//  HomeViewModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let service: AuthService = AuthService.shared
    
    var isLoading: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    var loginSuccess: PublishRelay = PublishRelay<Bool>()
    var errorMessage: PublishRelay = PublishRelay<String>()
    
    func loginUser(userRequest: LoginUserRequest){
        self.isLoading.accept(true)
        
        service.loginUser(with: userRequest) {[weak self] success, error in
            guard let self = self else { return }
            
            self.isLoading.accept(false)
            
            if let error {
                self.errorMessage.accept(error.localizedDescription)
                return
            }
            
            if success {
                self.loginSuccess.accept(true)
            }
            
            
        }
        
        
    }
    
}
    
