//
//  FirebaseManager.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 21.02.2025.
//

import Foundation
import FirebaseFirestore

class FirebaseManager {
    let db = Firestore.firestore()
    
    func addLevel(level: Int, letters: [String], words: [String], completion: @escaping (Error?) -> Void) {
        let levelData = LevelModel(level: level, letters: letters, words: words)
        
        do {
            try db.collection("levels").document("level_\(level)").setData(from: levelData) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}
