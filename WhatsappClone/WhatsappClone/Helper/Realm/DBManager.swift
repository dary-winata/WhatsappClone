//
//  DBManager.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Foundation
import RealmSwift

class DBManager {
    static var shared: DBManager = DBManager()
    
    let realm = try! Realm()
    
    init() {}
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("error for adding file to realm: \(error.localizedDescription)")
        }
    }
}
