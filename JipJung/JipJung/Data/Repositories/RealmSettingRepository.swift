//
//  RealmSettingRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift
import RealmSwift

final class RealmSettingRepository {
    private let localDBManager: LocalDBManageable
    
    init(localDBManager: LocalDBManageable) {
        self.localDBManager = localDBManager
    }
    
    func migrate<T: Object>(dataList: [T]) throws {
        for data in dataList {
            do {
                try localDBManager.writeData(data)
            } catch {
                throw error
            }
        }
    }
}
