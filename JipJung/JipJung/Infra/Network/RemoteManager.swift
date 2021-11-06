//
//  RemoteManager.swift
//  JipJung
//
//  Created by turu on 2021/11/06.
//

import Foundation

import FirebaseStorage
import RxSwift

enum Media: String {
    case audio
    case image
    case video
}

enum RemoteServiceError: String, Error {
    case invalidURL
    case failDataTaskDownload
    case noInternet
}

protocol RemoteServiceAccessible {
    func fetchMedia(key: String, type: Media) -> Single<Data>
}

final class RemoteManager {
    static let shared = RemoteManager()
    private let storage = Storage.storage()
    private init() {}
    
    func fetchMedia(key: String, type: Media) -> Single<Data> {
        let fullPath = type.rawValue + "/" + key
        let reference = storage.reference(withPath: fullPath)
        
        return Single<Data>.create { observer in
            reference.downloadURL { url, error in
                guard let url = url,
                      error == nil
                else {
                    observer(.failure(RemoteServiceError.invalidURL))
                    return
                }
                
                URLSession.shared.dataTask(with: url) { (data, _, error) in
                    guard let data = data,
                          error == nil
                    else {
                        observer(.failure(RemoteServiceError.failDataTaskDownload))
                        return
                    }
                    observer(.success(data))
                }.resume()
            }
            
            return Disposables.create()
        }
    }
}
