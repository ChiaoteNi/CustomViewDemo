//
//  FNSegmentCell.swift
//  Fano
//
//  Created by admin on 2019/7/9.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

class SegmentCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var isFocus: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
