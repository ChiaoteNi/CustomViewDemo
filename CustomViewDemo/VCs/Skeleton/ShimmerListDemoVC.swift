//
//  SkeletonCellDemoVC.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/10.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

class ShimmerListDemoVC: BaseVC {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
}

extension ShimmerListDemoVC {
    
    private func initSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ShimmerListCell.self)
    }
}

extension ShimmerListDemoVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(with: ShimmerListCell.self, for: indexPath)
        
        cell.titleLabel
            .set(\.text, to: "iOS@Taipei")
        cell.cateLabel
            .set(\.text, to: "開發者社群")
        cell.timeLabel
            .set(\.text, to: "更新於 2天前")
        
        if indexPath.item % 2 == 0 {
            cell.descLabel
                .set(\.text, to: "自由的文化，自然的聚集，交流，創造由一群自發性的科技人，新創人組成的實體聚會，互相分享，快樂的創造。每週禮拜二的iOS跨界自主技術與經驗交流，設計師，工程師，對iOS產業有興趣的都歡迎一起來聚會")
        } else {
            cell.descLabel
                .set(\.text, to: "自由的文化，自然的聚集，交流，創造由一群自發性的科技人")
        }
        
        cell.showShimmer()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width, height: 150)
    }
}
