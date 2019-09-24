//
//  SkeletonDemoVC.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/10.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

class ShimmerDemoVC: BaseVC {
    
    @IBOutlet private weak var skeletonView: ShimmerView!
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var coverImageView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var cateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel
            .set(\.text, to: "iOS@Taipei")
            .set(\.font, to: .demo_skeletonTitle)
        descLabel
            .set(\.text, to: "自由的文化，自然的聚集，交流，創造由一群自發性的科技人，新創人組成的實體聚會，互相分享，快樂的創造。每週禮拜二的iOS跨界自主技術與經驗交流，設計師，工程師，對iOS產業有興趣的都歡迎一起來聚會")
            .set(\.font, to: .demo_skeletonDesc)
        cateLabel
            .set(\.text, to: "開發者社群")
            .set(\.font, to: .demo_skeletonSubTitle)
        timeLabel
            .set(\.text, to: "更新於 2天前")
            .set(\.font, to: .demo_skeletonSubTitle)
        
        coverImageView
            .set(\.contentMode, to: .scaleToFill)
            .set(\.layer.contents, to: UIImage.iosTaipei.cgImage)
            .set(\.layer.masksToBounds, to: true)
        containerView
            .set(\.layer.shadowColor, to: UIColor.demo_shadow.cgColor)
            .set(\.layer.shadowOffset, to: .init(width: 1, height: -10))
            .set(\.layer.shadowRadius, to: 5)
            .set(\.layer.borderWidth, to: 1)
            .set(\.layer.borderColor, to: UIColor.demo_skeletonBorder.cgColor)
            .set(\.layer.cornerRadius, to: 5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coverImageView.layer.cornerRadius = min(coverImageView.frame.height, coverImageView.frame.width) / 2
    }
    
    @IBAction private func startAnimation() {
        skeletonView.startAnimating(on: [
            titleLabel,
            descLabel,
            cateLabel,
            timeLabel,
            coverImageView])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.skeletonView.stopAnimating()
        }
    }
}

