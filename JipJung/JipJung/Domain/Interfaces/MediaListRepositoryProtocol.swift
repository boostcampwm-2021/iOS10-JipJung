//
//  MediaListRepositoryProtocol.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

protocol MediaListRepositoryProtocol {
    func fetchAllMediaList() -> Single<[Media]>
    func fetchMediaMyList(mode: MediaMode) -> Single<[Media]>
    func fetchFavoriteMediaList() -> Single<[Media]>
    func fetchRecentPlayHistory() -> Single<[Media]>
}
