//
//  MediaListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MediaListRepository {
    private let localDBManager = RealmDBManager.shared
    
    func read() -> Single<[Media]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let result = try self.localDBManager.searchTest(ofType: Media.self)
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
    
    func read(for mode: MediaMode) -> Single<[Media]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            var mediaMyList: [String]?
            
            do {
                switch mode {
                case .bright:
                    mediaMyList = try self.localDBManager.searchTest(
                        ofType: BrightMedia.self
                    ).map { $0.mediaID }
                case .dark:
                    mediaMyList = try self.localDBManager.searchTest(
                        ofType: DarknessMedia.self
                    ).map { $0.mediaID }
                }
                
                guard let ids = mediaMyList else {
                    single(.failure(RealmError.searchFailed))
                    return Disposables.create()
                }
                let predicate = NSPredicate.init(format: "id IN %@", ids)
                let result = try self.localDBManager.searchTest(ofType: Media.self, with: predicate)
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
    
    func removeMediaFromMode(media: Media) -> Single<Bool> {
        return localDBManager.deleteMediaInMode(mediaID: media.id, mode: media.mode)
    }
    
    func removeMediaFromMode(id: String, mode: Int) -> Single<Bool> {
        return localDBManager.deleteMediaInMode(mediaID: id, mode: mode)
    }
    
    func saveMediaFromMode(id: String, mode: Int) -> Single<Bool> {
        let data = mode == 0 ? BrightMedia(id: id) : DarknessMedia(id: id)
        return localDBManager.write(data)
    }
}
