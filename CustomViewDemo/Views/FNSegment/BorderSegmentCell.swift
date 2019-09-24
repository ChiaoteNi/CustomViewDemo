//
//  FNBorderSegmentCell.swift
//  Fano
//
//  Created by admin on 2019/9/9.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

final class BorderSegmentCell: SegmentCell {
    
    override var isFocus: Bool {
        didSet { isFocusDidChange(to: isFocus) }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel
            .set(\.layer.masksToBounds, to: true)
            .set(\.layer.cornerRadius, to: 5)
            .set(\.layer.borderWidth, to: 1)
            .set(\.layer.borderColor, to: UIColor.demo_border.cgColor)
            .set(\.font, to: .demo_borderSegment)
            .set(\.textColor, to: .demo_borderSegmentText)
    }
    
    private func isFocusDidChange(to isFocus: Bool) {
        titleLabel.backgroundColor = isFocus ? UIColor.demo_borderSegmentBG : .clear
    }
}
