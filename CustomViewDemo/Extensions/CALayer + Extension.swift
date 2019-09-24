//
//  public extension + CALayer.swift
//  comic
//
//  Created by Admin on 2017/12/7.
//  Copyright © 2017年 Appimc. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {
    
   func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, forceLength: CGFloat = 0.0) {
        let border = CALayer()
        
        switch edge {
            case .top:
                border.frame = CGRect(x: (forceLength > 0) ? (frame.size.width - forceLength)/2.0 : 0,
                                      y: 0,
                                      width: (forceLength > 0) ? forceLength : frame.size.width,
                                      height: thickness)
            case .bottom:
                border.frame = CGRect(x: (forceLength > 0) ? (frame.size.width - forceLength)/2.0 :  0,
                                      y: frame.size.height - thickness,
                                      width: (forceLength > 0) ? forceLength : frame.size.width,
                                      height: thickness)
            case .left:
                border.frame = CGRect(x: 0,
                                      y: (forceLength > 0) ? (frame.height - forceLength)/2.0 : 0,
                                      width: thickness,
                                      height: (forceLength > 0) ? forceLength : frame.height)
            case .right:
                border.frame = CGRect(x: frame.size.width - thickness,
                                      y: (forceLength > 0) ? (frame.height - forceLength)/2.0 : 0,
                                      width: thickness,
                                      height: (forceLength > 0) ? forceLength : frame.size.height)
            default:
                break
        }
        border.backgroundColor = color.cgColor;
        addSublayer(border)
    }
    
    func setGradientBGColor(colors: [CGColor], locations: [NSNumber], direction: Direction = .vertical) {
        setGradientColor(colors: colors, locations: locations, direction: direction)
    }
    
    func setGradientBGColor(colors: [CIColor], locations: [NSNumber], direction: Direction = .vertical) {
        setGradientColor(colors: colors, locations: locations, direction: direction)
    }
    
    private func setGradientColor(colors: [Any], locations: [NSNumber], direction: Direction = .vertical) {
        let headerGradient = CAGradientLayer()
        headerGradient.frame = self.bounds
        headerGradient.colors = colors
        headerGradient.locations = locations
        
        if direction == .vertical {
            headerGradient.startPoint = CGPoint(x: 1, y: 0)
            headerGradient.endPoint   = CGPoint(x: 1, y: 1)
        } else {
            headerGradient.startPoint = CGPoint(x: 0, y: 1)
            headerGradient.endPoint   = CGPoint(x: 1, y: 1)
        }
        insertSublayer(headerGradient, at: 0)
    }
    
    enum Direction {
        case vertical
        case horizental
    }
}
