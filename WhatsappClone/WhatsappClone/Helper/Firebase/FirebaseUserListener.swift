//
//  FirebaseUserListener.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Firebase
import Foundation

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    // Mark: - Login
    func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        // call firebase function for user auth login
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            // check for error
            if error != nil {
                completion(error, false)
                return
            }
            
            // get the auth data result
            //check with guard
            guard let user = authDataResult?.user else {
                completion(NSError(), false)
                return
            }
            
            // download user data from firestore
            FirebaseHelper.downloadUserFromFirestore(userId: user.uid, email: email)
            
            // call completion
            completion(nil, user.isEmailVerified)
        }
    }
    
    // Mark: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        // Call Firebase Function for authentication register
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            // check for error
            if error != nil {
                completion(error)
                return
            }
            
            // get the auth data result
            //check with guard
            guard let user = authDataResult?.user else {
                completion(NSError())
                return
            }
            
            // send email verification
            self.sendEmailVerificationToEmail(user)
            
            // save user info to user default
            self.saveUser(email: email, uid: user.uid)
            completion(nil)
        }
    }
    
    // Func for send email verification
    private func sendEmailVerificationToEmail(_ user: FirebaseAuth.User) {
        user.sendEmailVerification { error in
            if error != nil {
                print("Error sending email verification")
            } else {
                print("Success sent email verification")
            }
        }
    }
    
    // func to save user to UserDefaults
    private func saveUser(email: String, uid: String) {
        // create object of user
        let user: UserModel = UserModel(id: uid, username: email, email: email, status: "", avatar: "", firstName: "", lastName: "")
        
        // save user to user defaults
        FirebaseHelper.saveUserToLocal(user)
        
        // save to firestore
        saveUserToFirestore(user)
    }
    
    // fun to save user to Firestore
    func saveUserToFirestore(_ user: UserModel) {
        do {
            try FirebaseHelper.FirebaseReference(.User).document(user.id).setData(from: user)
        } catch {
            print("Error Saving user to firestore: \(error.localizedDescription)")
        }
    }    
    // Mark: - Reset Password
    func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            if err == nil {
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    // Mark: - Logout User
    func logoutUser(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: keyCurrentUser)
            UserDefaults.standard.synchronize()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
