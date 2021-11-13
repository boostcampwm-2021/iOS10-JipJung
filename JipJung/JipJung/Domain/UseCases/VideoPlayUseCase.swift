//
//  VideoPlayUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

final class VideoPlayUseCase {
    enum VideoError: Error {
        case badURL
    }
    
    private let mediaResourceRepository = MediaResourceRepository()
    
    func ready(_ videoFileName: String) -> Single<URL> {
        mediaResourceRepository.getMediaURL(fileName: videoFileName, type: .video)
    }
}
