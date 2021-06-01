//
//  LocalDatabase.swift
//  alvingro
//
//  Created by Thành Nguyên on 31/05/2021.
//

import Foundation
import RealmSwift

class LocalDatabase {
    static let shared = LocalDatabase()
    
    private let db = try! Realm()
    
    private init() {}
    
    func getAll<T: Object>(targetType: T.Type) -> [T] {
        try! db.write {
            return db.objects(T.self).toArray(ofType: T.self)
        }
    }
    
    func getAnObject<T: Object>(key: String, value: String, ofType: T.Type) -> T? {
        try! db.write {
            return db.objects(T.self).filter("\(key) = %@", value).first
        }
    }
    
    func set<T: Object>(_ item: T) {
        try! db.write {
            db.add(item)
        }
    }
    
    func removeAnObject<T: Object>(ofType: T.Type, key: String, value: String) {
        if let object = db.objects(T.self).filter("\(key) = %@", value).first {
            try! db.write {
                db.delete(object)
            }
        }
    }
    
    func removeObjects<T: Object>(ofType: T.Type) {
        try! db.write {
            db.delete(db.objects(ofType.self))
        }
    }
    
    func isExist<T: Object>(key: String, value: String, ofType: T.Type) -> Bool {
        if let _ = db.objects(T.self).filter("\(key) = %@", value).first {
            return true
        }
        return false
    }
}
