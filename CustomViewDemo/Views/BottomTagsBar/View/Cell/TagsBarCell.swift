//
//  TagsBarCell.swift
//  BottomTagsBarTest
//
//  Created by Chiao-Te Ni on 2018/3/13.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class TagsBarCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    var info: Any?
    
    override var isSelected: Bool {
        didSet { resetStyle(isSelected: isSelected) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth   = 1
        backgroundColor     = .clear
        tagLabel.font       = .demo_bottomTagsBarItem
        resetStyle(isSelected: isSelected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    private func resetStyle(isSelected: Bool) {
        if isSelected {
            tagLabel.textColor  = .demo_tagSelected
            backgroundColor     = .demo_tagSelectedBG
            layer.borderColor   = UIColor.demo_tagSelectedBG.cgColor
        } else {
            tagLabel.textColor  = .demo_tagNormal
            backgroundColor     = .clear
            layer.borderColor   = UIColor.demo_border.cgColor
        }
    }
}
