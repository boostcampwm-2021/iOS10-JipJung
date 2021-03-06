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
    private var disposeBag = DisposeBag()
    
    private init() {}

    func migrateJsonData<T: Object>(dataList: [T]) throws {
        for data in dataList {
            do {
                try RealmDBManager.shared.add(data)
            } catch {
                throw error
            }
        }
    }
    
    func migrateSchema() throws {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    DispatchQueue.main.async {
                        guard let focusRecords = try? RealmDBManager.shared.objects(ofType: FocusRecord.self) else {
                            return
                        }
                        for focusRecord in focusRecords {
                            let dateKey = "\(focusRecord.year)\(focusRecord.month)\(focusRecord.day)"
                            let dateFocusRecord: DateFocusRecord
                            if let dateFocusRecordObject = try? RealmDBManager.shared.object(
                                ofType: DateFocusRecord.self,
                                forPrimaryKey: dateKey
                            ) {
                                dateFocusRecord = dateFocusRecordObject
                                try? dateFocusRecord.realm?.write({
                                    dateFocusRecord.focusTime.append(focusRecord)
                                })
                            } else {
                                dateFocusRecord = DateFocusRecord(id: dateKey)
                                dateFocusRecord.focusTime.append(focusRecord)
                            }
                            try? RealmDBManager.shared.add(dateFocusRecord)
                        }
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        _ = try? Realm()
    }
}
