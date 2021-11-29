//
//  LocalDBMigrator.swift
//  JipJung
//
//  Created by turu on 2021/11/14.
//

import Foundation

import RealmSwift
import RxSwift

final class LocalDBMigrator {
    static let shared = LocalDBMigrator()
    private init() {}
    
    func migrate<T: Object>(dataList: [T]) throws {
        for data in dataList {
            do {
                try RealmDBManager.shared.add(data)
            } catch {
                throw error
            }
        }
    }
}
