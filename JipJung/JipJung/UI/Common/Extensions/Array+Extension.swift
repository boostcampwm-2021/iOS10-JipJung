//
//  Array+Extension.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/14.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    subscript(loop index: Int) -> Element? {
        return isEmpty ? nil : self[(index + count) % count]
    }
    
    func elements(in range: Range<Int>) -> [Element] {
        var result: [Element] = []
        range.forEach { index in
            if indices ~= index {
                result.append(self[index])
            }
        }
        return result
    }
}
