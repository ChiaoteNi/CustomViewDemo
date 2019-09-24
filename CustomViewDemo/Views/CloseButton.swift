//
//  CloseButton.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/24.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

class CloseButton: UIView {
    
    var action: (()->Void)? = nil
    
    init(_ action: @escaping ()->Void) {
        self.action = action
        super.init(frame: .init(x: UIScreen.main.bounds.width - 45,
                                y: 50,
                                width: 35,
                                height: 35))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        addGestureRecognizer(tap)
        
        layer.contents = getCloseIcon().cgImage
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assert(false, "Not support GUI.")
    }
    
    @objc private func close() {
        action?()
    }
    
    private func getCloseIcon() -> UIImage {
        let diameter: CGFloat = 30
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: diameter / 2)
        
        let min = diameter * 0.25
        let max = diameter * 0.75
        path.move(to: .init(x: min, y: min))
        path.addLine(to: .init(x: max, y: max))
        path.move(to: .init(x: max, y: min))
        path.addLine(to: .init(x: min, y: max))
        
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
        layer.lineWidth = 2
        layer.path = path.cgPath
        
        guard let icon: UIImage = UIImage.init(layer: layer) else { return .init() }
        return icon
    }
}
