//
//  HomeViewModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    private let service = AuthService.shared
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let registerSuccess = PublishRelay<Bool>()
    let errorMessage = PublishRelay<String>()
    
    func registerUser(userRequest: RegisterUserRequest) {
        isLoading.accept(true)
        
        service.registerUser(with: userRequest) { [weak self] success, error in
            guard let self = self else { return }
            
            self.isLoading.accept(false)
            
            if let error = error {
                self.errorMessage.accept(error.localizedDescription)
            } else {
                self.registerSuccess.accept(success)
            }
        }
    }
}
