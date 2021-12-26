//
//  RealmDBManager.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift

final class RealmDBManager {
    static let shared = RealmDBManager()
    private init() {}
    
    func object<Entity: Object>(ofType: Entity.Type, forPrimaryKey: String) throws -> Entity? {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        return realm.object(ofType: ofType, forPrimaryKey: forPrimaryKey)
    }
    
    func objects<Entity: Object>(ofType: Entity.Type, with predicate: NSPredicate? = nil) throws -> [Entity] {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        if let predicate = predicate {
            return Array(realm.objects(Entity.self).filter(predicate))
        } else {
            return Array(realm.objects(Entity.self))
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
