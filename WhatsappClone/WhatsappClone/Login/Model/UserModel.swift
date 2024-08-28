//
//  UserModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Foundation
import Firebase

struct UserModel: Equatable, Codable {
    var id: String = ""
    var username: String
    var email: String
    var status: String
    var pushId: String = ""
    var avatar: String = ""
    var firstName: String?
    var lastName: String?
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id
    }
}
