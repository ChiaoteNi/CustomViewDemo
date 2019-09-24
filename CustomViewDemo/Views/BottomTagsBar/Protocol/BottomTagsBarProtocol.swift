//
//  ButtonTagsBarViewProtocol.swift
//  BottomTagsBarTest
//
//  Created by Chiao-Te Ni on 2018/3/12.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import UIKit

typealias BottomTagsBarSpec = BottomTagsBarDataSource & BottomTagsBarDelegate

protocol BottomTagsBarDataSource: class {
    func bottomTagsBar(numberOfItemsIn collectionView: UICollectionView) -> Int
    func bottomTagsBar(_ collectionView: UICollectionView, cellForItemAt index: Int, cell: TagsBarCell)
}

@objc protocol BottomTagsBarDelegate: class {
    // Require func.
    func bottomTagsBar(_ collectionView: UICollectionView, didSelectItemAt index: Int, cell: TagsBarCell)
    
    // Optional ActionDelegate func
    @objc optional func bottomTagsBar(didScroll collectionView: UICollectionView)
    @objc optional func bottomTagsBar(didScrollToTop collectionView: UICollectionView)
    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, didDeselectItemAt index: Int, item: TagsBarCell)
    
    // Optional FlowLayoutDelegate func
    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, widthForItemAt index: Int) -> CGFloat
    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    //    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt index: Int) -> CGSize
    //    @objc optional func bottomTagsBar(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

