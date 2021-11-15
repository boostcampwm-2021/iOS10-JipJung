//
//  CollectionView+MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/10.
//

import UIKit

extension MusicPlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionView.CellIdentifier.tag.value,
            for: indexPath
        ) as? TagCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = dataSource[indexPath.item]
        return cell
    }
}

extension MusicPlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = dataSource[indexPath.item]
        label.sizeToFit()
        
        let size = label.frame.size
        
        return CGSize(width: size.width + 16, height: size.height + 10)
    }
}

class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
          if layoutAttribute.representedElementCategory == .cell {
            if layoutAttribute.frame.origin.y >= maxY {
              leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
          }
        }
        
        return attributes
      }
}
