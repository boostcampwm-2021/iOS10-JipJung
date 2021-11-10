//
//  RemoteManager.swift
//  JipJung
//
//  Created by turu on 2021/11/06.
//

import Foundation

import FirebaseStorage
import RxSwift

final class RemoteServiceProvider: RemoteServiceAccessible {
    private let storage = Storage.storage()
    
    func request(key: String, type: MediaType) -> Single<URL> {
        let fullPath = type.rawValue + "/" + key
        let reference = storage.reference(withPath: fullPath)
        
        return Single<URL>.create { single in
            reference.downloadURL { url, error in
                guard let url = url,
                      error == nil
                else {
                    single(.failure(RemoteServiceError.badURL))
                    return
                }
                
                URLSession.shared.downloadTask(with: url) { (url, response, error) in
                    guard let url = url,
                          error == nil
                    else {
                        single(.failure(RemoteServiceError.transportError))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse,
                          (200 ..< 300) ~= response.statusCode
                    else {
                        return single(.failure(RemoteServiceError.serverSideError))
                    }
                    
                    single(.success(url))
                }.resume()
            }
            
            return Disposables.create()
        }
    }
}
