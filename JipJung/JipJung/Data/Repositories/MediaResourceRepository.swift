//
//  MediaResourceRepository.swift
//  JipJung
//
//  Created by turu on 2021/11/08.
//

import Foundation

import RxSwift

final class MediaResourceRepository {
    private let localFileManager: LocalFileAccessible
    private let remoteServiceProvider: RemoteServiceAccessible
    
    init(
        localFileManager: LocalFileAccessible,
        remoteServiceProvider: RemoteServiceAccessible
    ) {
        self.localFileManager = localFileManager
        self.remoteServiceProvider = remoteServiceProvider
    }
    
    func fetch(fileName: String, type: MediaType) -> Single<Data> {
        let localFileManager = self.localFileManager
        if let localFileData = try? localFileManager.read(fileName) {
            return Single.just(localFileData)
        }
        
        return remoteServiceProvider.request(key: fileName, type: type)
            .map { url in try localFileManager.move(from: url, to: fileName) }
            .map { try localFileManager.read(fileName) }
    }
}
