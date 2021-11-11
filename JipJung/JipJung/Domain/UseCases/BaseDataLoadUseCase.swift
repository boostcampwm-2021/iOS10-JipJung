//
//  BaseDataLoadUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

class BaseDataLoadUseCase {
    private let mediaListRepository: MediaListRepositoryProtocol
    
    init(mediaListRepository: MediaListRepository) {
        self.mediaListRepository = mediaListRepository
    }
    
    func isLoaded() -> Bool {
        return false
    }
    
    func load() {
        guard let url = Bundle.main.url(forResource: "DummyData", withExtension: "json"),
              let jsonData = try? JSONSerialization.jsonObject(with: Data(contentsOf: url))
        else {
            return
        }
        
        print(jsonData)
    }
}
