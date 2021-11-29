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
    
    // MARK: Media
    
    func read() -> Single<[Media]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let result = try self.localDBManager.objects(ofType: Media.self)
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
    
    // MARK: MediaMode
    
    func create(mediaID: String, mode: Int) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            // TODO: ViewModel에서 MediaMode를 가져오도록 변경 후 삭제
            guard let mode = MediaMode(rawValue: mode) else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                switch mode {
                case .bright:
                    let brightMedia = BrightMedia(mediaID: mediaID)
                    try brightMedia.autoIncrease()
                    try self.localDBManager.add(brightMedia)
                case .dark:
                    let darknessMedia = DarknessMedia(mediaID: mediaID)
                    try darknessMedia.autoIncrease()
                    try self.localDBManager.add(darknessMedia)
                }
            } catch {
                single(.failure(error))
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
                    mediaMyList = try self.localDBManager.objects(
                        ofType: BrightMedia.self
                    ).map { $0.mediaID }
                case .dark:
                    mediaMyList = try self.localDBManager.objects(
                        ofType: DarknessMedia.self
                    ).map { $0.mediaID }
                }
                
                guard let ids = mediaMyList else {
                    throw RealmError.searchFailed
                }
                let predicate = NSPredicate.init(format: "id IN %@", ids)
                let result = try self.localDBManager.objects(ofType: Media.self, with: predicate)
                single(.success(result))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func delete(mediaID: String, mode: Int) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            // TODO: ViewModel에서 MediaMode를 가져오도록 변경 후 삭제
            guard let mode = MediaMode(rawValue: mode) else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let predicate = NSPredicate(format: "mediaID = %@", mediaID)
                
                switch mode {
                case .bright:
                    let deletingMedia = try self.localDBManager.objects(
                        ofType: BrightMedia.self,
                        with: predicate
                    ).first
                    
                    if let deletingMedia = deletingMedia {
                        try self.localDBManager.delete(deletingMedia)
                    }
                case .dark:
                    let deletingMedia = try self.localDBManager.objects(
                        ofType: DarknessMedia.self,
                        with: predicate
                    ).first
                    
                    if let deletingMedia = deletingMedia {
                        try self.localDBManager.delete(deletingMedia)
                    }
                }
                
                single(.success(true))
            } catch {
                single(.failure(RealmError.deleteFailed))
            }
            return Disposables.create()
        }
    }
}
