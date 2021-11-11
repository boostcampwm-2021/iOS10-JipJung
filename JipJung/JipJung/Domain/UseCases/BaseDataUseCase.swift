//
//  BaseDataUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

final class BaseDataUseCase {
//    private let mediaListRepository: MediaListRepositoryProtocol
//    
//    init(mediaListRepository: MediaListRepository) {
//        self.mediaListRepository = mediaListRepository
//    }
    
    func isLoaded() -> Bool {
        return false
    }
    
    func load() {
        guard let url = Bundle.main.url(forResource: "DummyData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonValue = try? JSONDecoder().decode(DBStructureForJSON.self, from: data)
        else {
            return
        }
        print(jsonValue)
    }
}
