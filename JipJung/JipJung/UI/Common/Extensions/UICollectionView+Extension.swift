//
//  UICollectionView+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/14.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        return register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}
