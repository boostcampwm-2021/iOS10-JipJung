//
//  LocalDBManagable.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RealmSwift
import RxSwift

protocol LocalDBManageable {
    func search<T: Object>(with predicate: NSPredicate?) -> Single<[T]>
    func write(_ value: Object) -> Single<Bool>
    func delete(_ value: Object) -> Single<Bool>
    func requestMediaList(mode: MediaMode?) -> Single<[Media]>
    func requestRecentPlayHistory() -> Single<[Media]>
    func requestFavoriteMediaList() -> Single<[Media]>
    func requestMaximList() -> Single<[Maxim]>
    func requestFavoriteMaximList() -> Single<[Maxim]>
}
