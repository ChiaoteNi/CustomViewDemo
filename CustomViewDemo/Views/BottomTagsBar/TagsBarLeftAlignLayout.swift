//
//  TagsBarLeftAlignLayout
//  PageVCwithXibTest
//
//  Created by Chiao-Te Ni on 2018/3/9.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

///居左布局
class TagsBarLeftAlignLayout: UICollectionViewFlowLayout {
    
    var delegate: UICollectionViewDelegateFlowLayout?
    var attrArr = [UICollectionViewLayoutAttributes]()
    
    var maxY: CGFloat = 0.0
    var totalLineInSections: [CGFloat] = []
    var extraBtnSize: CGSize = .zero
    
    private var columnHeights = [CGFloat]()
    private var widths = [CGFloat]()
    var supplementaryViewOfKind = ""
    
    override func prepare() {
        maxY = 0
        
        attrArr = [UICollectionViewLayoutAttributes]()
        columnHeights = [CGFloat]()
        widths = [CGFloat]()
        supplementaryViewOfKind = ""
        
        guard let collectionView = self.collectionView else { return }
        
        var coordinate = [CGRect]()
        totalLineInSections.removeAll()
//        maxY += collectionView.contentInset.top
        
        for section in 0 ..< collectionView.numberOfSections {
            let collectionWidth = (collectionView.frame.width)
            
            var x: CGFloat = 0.0
            var y: CGFloat = maxY
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            
            if let newSectionInset = delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
                sectionInset = newSectionInset
            }
            let left = collectionView.contentInset.left + sectionInset.left
            y += sectionInset.top
            
            var linesInSection: CGFloat = 0
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            for i in 0 ..< itemCount {
                let indexPath = IndexPath(item: i, section: section)
                let size = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize(width: 50, height: 30)
                width = size.width > collectionWidth ? collectionWidth : size.width
                height = size.height
                
                if coordinate.count == 0 {
                    x = left
                } else if let lastFrame = coordinate.last {
                    x = lastFrame.maxX + (delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: i) ?? minimumInteritemSpacing)
                    let limitWidth = y <= extraBtnSize.height ? collectionWidth - extraBtnSize.width : collectionWidth
                    if x + width > (sectionInset.right + sectionInset.left + left + limitWidth) {
                        x = left
                        y += (delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: i) ?? minimumLineSpacing) + height
                        linesInSection += 1
                    }
                }
                
                let frame = CGRect(x: x, y: y, width: width, height: height)
                coordinate.append(frame)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame = frame
                attrArr.append(attr)
            }
            totalLineInSections.append(linesInSection)
            coordinate.removeAll(keepingCapacity: true)
            y += sectionInset.bottom + height
            maxY = y
        }
//        maxY += collectionView.contentInset.bottom
    }
    
    override var collectionViewContentSize: CGSize {
        let size = super.collectionViewContentSize
//        maxY = max(size.height, maxY)
        return CGSize(width: size.width, height: maxY)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArr
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
}

