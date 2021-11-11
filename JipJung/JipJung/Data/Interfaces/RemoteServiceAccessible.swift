//
//  RemoteServiceAccessible.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

protocol RemoteServiceAccessible {
    func request(key: String, type: MediaType) -> Single<URL>
}
