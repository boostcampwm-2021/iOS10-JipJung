//
//  UICollectionView+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/14.
//

import UIKit

extension UICollectionView {
    func cell(identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
