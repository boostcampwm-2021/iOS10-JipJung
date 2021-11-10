//
//  RemoteServiceRepository.swift
//  JipJung
//
//  Created by turu on 2021/11/08.
//

import Foundation

import RxSwift

enum MediaRepositoryError: Error {
    case fileNotFound
    case fileCopyError
}

final class MediaRepository {
    private let remoteServiceProvider: RemoteServiceAccessible
    
    init(remoteServiceAccessible: RemoteServiceAccessible) {
        self.remoteServiceProvider = remoteServiceAccessible
    }
    
    func fetch(fileName: String, type: MediaType) -> Single<Data> {
        if let data = LocalFileManager.shared.read(fileName) {
            return Single.just(data)
        }
        
        return remoteServiceProvider.request(key: fileName, type: type)
            .map { url in LocalFileManager.shared.move(from: url, to: fileName) }
            .map { isSucceed in
                switch isSucceed {
                case true:
                    guard let data = LocalFileManager.shared.read(fileName) else {
                        throw MediaRepositoryError.fileNotFound
                    }
                    return data
                case false:
                    throw MediaRepositoryError.fileCopyError
                }
            }
    }
}
