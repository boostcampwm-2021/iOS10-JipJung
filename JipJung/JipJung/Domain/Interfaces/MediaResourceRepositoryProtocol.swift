//
//  MediaResourceRepositoryProtocol.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

protocol MediaResourceRepositoryProtocol {
    func getMediaURL(fileName: String, type: MediaType) -> Single<URL>
    func fetchData(fileName: String, type: MediaType) -> Single<Data>
}
