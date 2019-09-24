//
//  BaseVC.swift
//  LayoutWithCoreText
//
//  Created by aaron Ni on 2019/7/28.
//  Copyright © 2019 iOS＠Taipei. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var closeBtn: UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeBtn.setTitle("", for: .normal)
        closeBtn.setImage(getCloseIcon(), for: .normal)
        closeBtn.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: 50, width: 35, height: 35)
        closeBtn.addTarget(self, action: #selector(close), for: UIControl.Event.allEvents)
        view.insertSubview(closeBtn, at: 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.bringSubviewToFront(closeBtn)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
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
