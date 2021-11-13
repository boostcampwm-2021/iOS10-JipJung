//
//  BaseDataUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

final class BaseDataUseCase {
    private let realmSettingRepository = RealmSettingRepository()
    
    let bag = DisposeBag()
    
    init(realmSettingRepository: RealmSettingRepository) {
        self.realmSettingRepository = realmSettingRepository
    }
    
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
        
        do {
            try realmSettingRepository.migrate(dataList: jsonValue.allMediaList)
            try realmSettingRepository.migrate(dataList: jsonValue.brightModeList)
            try realmSettingRepository.migrate(dataList: jsonValue.darknessModeList)
            try realmSettingRepository.migrate(dataList: jsonValue.playHistoryList)
            try realmSettingRepository.migrate(dataList: jsonValue.favoriteMediaList)
        } catch {
            print(error)
        }
    }
}
