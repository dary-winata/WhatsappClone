//
//  FirebaseHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Foundation
import Firebase

class FirebaseHelper {
    // Mark: - User
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
    
    //Reference
    static func FirebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    
    // func to save user locally
    static func saveUserToLocal(_ user: UserModel) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: keyCurrentUser)
        } catch {
            print("Error Encode User: \(error.localizedDescription)")
        }
    }
    
    // Mark: - Download
    static func downloadUserFromFirestore(userId: String, email: String? = nil) {
        // call firebase function to download user data
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            // check for error
            if error != nil {
                print("Error getting document: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let document = snapshot else {
                print("Error: No Document Found")
                return
            }
            
            // download data
            let result = Result {
                try? document.data(as: UserModel.self)
            }
            
            switch result {
            case .success(let userObj):
                if let user = userObj {
                    // save userdata to local
                    saveUserToLocal(user)
                } else {
                    print("No User Found")
                }
            case .failure(let error):
                print("error endcoding user: \(error.localizedDescription)")
            }
        }
    }
}
