//
//  SkeletonListCell.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/10.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

class ShimmerListCell: UICollectionViewCell {

    @IBOutlet private weak var shimmerView: ShimmerView!
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var coverImageView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel
            .set(\.font, to: .demo_skeletonTitle)
        descLabel
            .set(\.font, to: .demo_skeletonDesc)
        cateLabel
            .set(\.font, to: .demo_skeletonSubTitle)
        timeLabel
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        coverImageView.layer.cornerRadius = min(coverImageView.frame.height, coverImageView.frame.width) / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.layer.cornerRadius = min(coverImageView.frame.height, coverImageView.frame.width) / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shimmerView.stopAnimating()
    }
    
    func showShimmer() {
        shimmerView.startAnimating(on: [
            titleLabel,
            descLabel,
            cateLabel,
            timeLabel,
            coverImageView
            ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.shimmerView.stopAnimating()
        }
    }
}
