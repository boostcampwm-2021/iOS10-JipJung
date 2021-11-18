//
//  CheckMusicDownloadedUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation

final class FetchMediaURLUseCase {
    private let localFileManager = LocalFileManager.shared
    private let remoteServiceProvider = RemoteServiceProvider.shared
    
    func execute(fileName: String) -> URL? {
        if let fileURL = BundleManager.shared.findURL(fileNameWithExtension: fileName) {
            return fileURL
        }
        if let fileURL = localFileManager.isExsit(fileName) {
            return fileURL
        }
        return nil
    }
}
