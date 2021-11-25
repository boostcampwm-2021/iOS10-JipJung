//
//  CheckMusicDownloadedUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation

import RxSwift

final class FetchMediaURLUseCase {
    private let mediaResourceRepository = MediaResourceRepository()
    
    func getMediaURL(fileName: String, type: MediaType) -> Single<URL> {
        return mediaResourceRepository.getMediaURL(fileName: fileName, type: type)
    }
    
    func getMediaURLFromLocal(fileName: String) -> Single<URL> {
        return mediaResourceRepository.getMediaURLFromLocal(fileName: fileName)
    }
}
