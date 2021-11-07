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

enum RemoteServiceError: Error {
    case transportError
    case serverSideError
    case badURL
}

protocol RemoteServiceAccessible {
    func fetchMedia(key: String, type: Media) -> Single<Data>
}

final class RemoteServiceProvider: RemoteServiceAccessible {
    private let storage = Storage.storage()
    
    func fetchMedia(key: String, type: Media) -> Single<Data> {
        let fullPath = type.rawValue + "/" + key
        let reference = storage.reference(withPath: fullPath)
        
        return Single<Data>.create { observer in
            reference.downloadURL { url, error in
                guard let url = url,
                      error == nil
                else {
                    observer(.failure(RemoteServiceError.badURL))
                    return
                }
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data,
                          error == nil
                    else {
                        observer(.failure(RemoteServiceError.transportError))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse,
                          (200 ..< 300) ~= response.statusCode
                    else {
                        return observer(.failure(RemoteServiceError.serverSideError))
                    }
                    
                    observer(.success(data))
                }.resume()
            }
            
            return Disposables.create()
        }
    }
}
