//
//  MediaPlayViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/25.
//

import Foundation

import RxSwift

final class MediaPlayViewModel {
    private let fetchMediaURLUseCase = FetchMediaURLUseCase()
    
    func didSetMedia(fileName: String, type: MediaType) -> Single<URL> {
        return fetchMediaURLUseCase.getMediaURL(fileName: fileName, type: type)
    }
}
