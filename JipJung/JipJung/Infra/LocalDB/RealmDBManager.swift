//
//  RealmDBManager.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift
import RxSwift

class RealmDBManager {
    static let shared = RealmDBManager()
    private init() {}
    
    func objects<T: Object>(ofType: T.Type, with predicate: NSPredicate? = nil) throws -> [T] {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        if let predicate = predicate {
            return Array(realm.objects(T.self).filter(predicate))
        } else {
            return Array(realm.objects(T.self))
        }
    }
    
    func add(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        do {
            try realm.write({
                realm.add(value, update: .all)
            })
        } catch {
            throw RealmError.addFailed
        }
    }
    
    func delete(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        do {
            try realm.write({
                realm.delete(value)
            })
        } catch {
            throw RealmError.deleteFailed
        }
    }
}
