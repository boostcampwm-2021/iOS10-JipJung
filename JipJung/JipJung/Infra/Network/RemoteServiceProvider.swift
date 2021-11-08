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
    func request(key: String, type: Media) -> Single<URL>
}

final class RemoteServiceProvider: RemoteServiceAccessible {
    private let storage = Storage.storage()
    
    func request(key: String, type: Media) -> Single<URL> {
        let fullPath = type.rawValue + "/" + key
        let reference = storage.reference(withPath: fullPath)
        
        return Single<URL>.create { observer in
            reference.downloadURL { url, error in
                guard let url = url,
                      error == nil
                else {
                    observer(.failure(RemoteServiceError.badURL))
                    return
                }
                
                URLSession.shared.downloadTask(with: url) { (url, response, error) in
                    guard let url = url,
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
                    
                    observer(.success(url))
                }.resume()
            }
            
            return Disposables.create()
        }
    }
}
