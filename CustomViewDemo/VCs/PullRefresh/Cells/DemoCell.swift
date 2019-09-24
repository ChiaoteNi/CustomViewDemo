//
//  DemoCell.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/10.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

class DemoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.addBorder(edge: .bottom,
                        color: .demo_border,
                        thickness: 1,
                        forceLength: rect.width - 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
