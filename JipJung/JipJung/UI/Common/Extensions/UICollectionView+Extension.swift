//
//  UICollectionView+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/14.
//

import UIKit

extension UICollectionView {
    enum CellIdentifier {
        case music
        case soundTag
        case tag
        case media
        
        var value: String {
            switch self {
            case .music:
                return String(describing: MusicCollectionViewCell.self)
            case .soundTag:
                return String(describing: SoundTagCollectionViewCell.self)
            case .tag:
                return String(describing: TagCollectionViewCell.self)
            case .media:
                return String(describing: MediaCollectionViewCell.self)
            }
        }
    }
    
    func cell(identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
