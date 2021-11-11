//
//  MaximListRepositoryProtocol.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

protocol MaximListRepositoryProtocol {
    func fetchAllMaximList() -> Single<[Maxim]>
    func fetchFavoriteMaximList() -> Single<[Maxim]>
}
