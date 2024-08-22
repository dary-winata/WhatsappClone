//
//  FirebaseHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Foundation
import Firebase

class FirebaseHelper {
    static var getCurrentId: String {
        guard let uid = Auth.auth().currentUser?.uid else {
            return "error getting uid"
        }
        return uid
    }
    
    static var getCurrentUser: UserModel? {
        if Auth.auth().currentUser != nil {
            if let userDict = UserDefaults.standard.data(forKey: keyCurrentUser) {
                let decoder = JSONDecoder()
                
                do {
                    let user = try decoder.decode(UserModel.self, from: userDict)
                    return user
                } catch {
                    print("Error Decode User: \(error.localizedDescription)")
                }
            }
        }
        
        return nil
    }
}
