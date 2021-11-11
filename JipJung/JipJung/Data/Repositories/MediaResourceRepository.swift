//
//  MediaResourceRepository.swift
//  JipJung
//
//  Created by turu on 2021/11/08.
//

import Foundation

import RxSwift

final class MediaResourceRepository: MediaResourceRepositoryProtocol {
    private let localFileManager: LocalFileAccessible
    private let remoteServiceProvider: RemoteServiceAccessible
    
    init(
        localFileManager: LocalFileAccessible,
        remoteServiceProvider: RemoteServiceAccessible
    ) {
        self.localFileManager = localFileManager
        self.remoteServiceProvider = remoteServiceProvider
    }
    
    func getMediaURL(fileName: String, type: MediaType) -> Single<URL> {
        let localFileManager = self.localFileManager
        
        if let fileURL = localFileManager.isExsit(fileName) {
            return Single.just(fileURL)
        }
        
        return remoteServiceProvider.request(key: fileName, type: type)
            .map { try localFileManager.move(from: $0, to: fileName) }
    }
    
    func fetchData(fileName: String, type: MediaType) -> Single<Data> {
        let localFileManager = self.localFileManager
        if let localFileData = try? localFileManager.read(fileName) {
            return Single.just(localFileData)
        }
        
        return remoteServiceProvider.request(key: fileName, type: type)
            .map { try localFileManager.move(from: $0, to: fileName) }
            .map { try localFileManager.read($0) }
    }
}
