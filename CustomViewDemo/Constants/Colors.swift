//
//  Colors.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/8.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var demo_shadow: UIColor              { return .black }
    static var demo_border: UIColor              { return UIColor(hexString: "C8C7CC") }
    
    static var demo_skeletonBorder: UIColor { return .lightGray }
    
    static var demo_refreshFooterTitle: UIColor  { return UIColor(white: 103.0 / 255.0, alpha: 1.0) }
    
    static var demo_scrollTopDownBorder: UIColor { return UIColor(hexString: "D9D9D9") }
    static var demo_bottomTagBarBG: UIColor      { return UIColor(hexString: "F9F9F9") }
    
    static var demo_scrollTopDownText: UIColor   { return UIColor(hexString: "666666") }
    
    static var demo_tagSelected: UIColor    { return UIColor(hexString: "666666") }
    static var demo_tagSelectedBG: UIColor  { return UIColor(hexString: "666666") }
    static var demo_tagNormal: UIColor      { return UIColor(hexString: "666666") }
    
    static var demo_borderSegmentBorder: UIColor    { return UIColor(hexString: "C8C7CC") }
    static var demo_borderSegmentText: UIColor      { return .darkGray }
    static var demo_borderSegmentBG: UIColor        { return .lightGray }
    
    static var demo_segmentTxt: UIColor        { return UIColor(hexString: "676767") }
    static var demo_segmentTxtFocused: UIColor { return UIColor(hexString: "333333") }
    static var demo_segmentBG: UIColor         { return .white }
    static var demo_segmentIndicator: UIColor  { return UIColor(red: 32.0 / 255.0, green: 161.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0) }
    
    static var fn_feedBackSegmentItemBG: UIColor    { return UIColor(white: 231.0 / 255.0, alpha: 1.0) }
    static var fn_feedBackSegmentTxt: UIColor       { return UIColor(white: 103.0 / 255.0, alpha: 1.0) }
}
