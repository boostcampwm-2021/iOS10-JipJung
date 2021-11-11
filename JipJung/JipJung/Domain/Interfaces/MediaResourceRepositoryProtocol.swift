//
//  MediaResourceRepositoryProtocol.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

protocol MediaResourceRepositoryProtocol {
    func fetch(fileName: String, type: MediaType) -> Single<Data>
}
