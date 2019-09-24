//
//  SkeletonView.swift
//  Fano
//
//  Created by admin on 2019/8/13.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

class ShimmerView: UIView {
    
    // Gradient
    private var startLocations: [NSNumber] = [-1.0, -0.5, 0.0]
    private var endLocations: [NSNumber] = [1.0, 1.5, 2.0]
    
    private var gradientBackgroundColor: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    private var gradientMovingColor: CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    
    // Animatiom
    private var movingAnimationDuration: CFTimeInterval = 0.8
    private var delayBetweenAnimationLoops: CFTimeInterval = 1.0
    
    private var gradientLayer: CAGradientLayer?
    
    // Mask
    private var maskPathTemplateStorage: [UIView?]?
    
    private var animationStartTime: Date?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        guard let maskPathTemplateStorage = maskPathTemplateStorage else { return }
        setMask(by: maskPathTemplateStorage)
    }
    
    override func layoutSubviews() {
        guard let maskPathTemplateStorage = maskPathTemplateStorage else { return }
        setMask(by: maskPathTemplateStorage)
    }

    func startAnimating(on views: [UIView], immediately: Bool = false) {
        DispatchQueue.main.async {
            self.animationStartTime = Date()
            self.maskPathTemplateStorage = views
            
            self.initGradientLayer()
            guard let gradientLayer = self.gradientLayer else { return }
            if immediately { self.setMask(by: views) }
            
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = self.startLocations
            animation.toValue = self.endLocations
            animation.duration = self.movingAnimationDuration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
            animationGroup.animations = [animation]
            animationGroup.repeatCount = .infinity
            gradientLayer.add(animationGroup, forKey: animation.keyPath)
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.maskPathTemplateStorage = nil
            
            if let time = self.animationStartTime, Date().timeIntervalSince(time) <= 0.45 {
                self.gradientLayer?.removeAllAnimations()
                self.gradientLayer?.removeFromSuperlayer()
                self.gradientLayer = nil
            } else {
                self.animation(duration: 0.25, snapAfterUpdate: false) { [weak self] in
                    self?.gradientLayer?.removeAllAnimations()
                    self?.gradientLayer?.removeFromSuperlayer()
                    self?.gradientLayer = nil
                }
            }
        }
    }
}

extension ShimmerView {
    
    private func initGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]
        gradientLayer.locations = startLocations
        layer.addSublayer(gradientLayer)
        
        self.gradientLayer = gradientLayer
    }
    
    private func setMask(by views: [UIView?]) {
        layer.mask = nil
        
        let path: CGMutablePath = .init()
        for view in views {
            guard let view = view else { continue }
            if view.layer.cornerRadius != 0 {
                let radius = min(view.frame.height / 2,
                                 max(0, view.layer.cornerRadius))
                path.addRoundedRect(in: view.frame,
                                    cornerWidth: radius,
                                    cornerHeight: radius)
            } else {
                path.addRect(view.frame)
            }
        }
        
        let maskLayer: CAShapeLayer = .init()
        maskLayer.path = path
        layer.mask = maskLayer
    }
}
