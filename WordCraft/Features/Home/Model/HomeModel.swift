//
//  HomeModel.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 19.02.2025.
//

import Foundation


struct UserModel: Codable {
    let username: String
    let rank: Int
    let point: Int
    let completedLevel: Int
    let avatar: String
    let notifications: [NotificationModel]
    
}
struct NotificationModel: Codable {
    let title: String
    let content: String
    let isRead: Bool
    
}


struct LevelModel: Codable {
    var level: Int
    var letters: [String]
    var words: Array<String>
    
}

struct ChallengeModel {
    var challengeName: String
    var challengeContent: String
    
}
