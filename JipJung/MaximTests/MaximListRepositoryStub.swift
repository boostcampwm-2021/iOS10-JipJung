//
//  MaximListRepositoryStub.swift
//  MaximTests
//
//  Created by 윤상진 on 2021/11/30.
//

import Foundation

import RxSwift

struct MaximListRepositoryStub: MaximListRepositoriable {
    let testData: [Maxim]
    
    func read(from date: Date) -> Single<[Maxim]> {
        return Observable.of(testData).asSingle()
    }
}
