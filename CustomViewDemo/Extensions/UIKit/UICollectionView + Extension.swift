//
//  public extension + IUCollectionView.swift
//  comic
//
//  Created by Admin on 2017/12/7.
//  Copyright © 2017年 Appimc. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    
   func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
   func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
   func register<T: UICollectionReusableView>(reusableViewType: T.Type,
                                               of kind: String = UICollectionView.elementKindSectionHeader) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
   func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type],
                                               kind: String = UICollectionView.elementKindSectionHeader) {
        reusableViewTypes.forEach { register(reusableViewType: $0, of: kind) }
    }
    
   func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                      for indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T else {
            print("cell not exist.")
            return nil
        }
        return cell
    }
    
   func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                          for indexPath: IndexPath,
                                                          of kind: String = UICollectionView.elementKindSectionHeader) -> T? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as? T
    }
    
   func getCell <T: UICollectionViewCell> (with type:T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(with: type, for: indexPath) else {
            return T()
        }
        return cell
    }
    
   func scrollToTop(animated: Bool = false) {
        let index = IndexPath(item: 0, section: 0)
        guard self.dataSource?.numberOfSections?(in: self) != 0 else { return }
        guard self.dataSource?.collectionView(self, numberOfItemsInSection: 0) != 0 else { return }
        self.scrollToItem(at: index, at: .top, animated: animated)
    }
    
}


