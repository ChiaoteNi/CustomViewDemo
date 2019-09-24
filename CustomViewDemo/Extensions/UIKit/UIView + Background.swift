//
//  UIView + Background.swift
//  Fano
//
//  Created by admin on 2019/7/1.
//  Copyright © 2019 paradise. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 設定背景色
extension UIView {
    
    /// 用Graphic晶片將img當color畫到View上 （因為抓frame, 要放在layout完成之後）
    ///
    /// - Parameters:
    ///   - img: img source
    ///   - type: 佈滿模式
    ///   - backgroundColor: 圖片以外的底色
    func setBackgroundImage(with img: UIImage, withContentType type: BgImgContentMode = .fill, backgroundColor: UIColor) {
        UIGraphicsBeginImageContext(self.bounds.size)
        // 畫底色
        backgroundColor.setFill()
        UIRectFill(self.bounds)
        // 上圖
        let viewSize = bounds.size
        let imgSize = img.size
        let drawRect: CGRect
        
        switch type {
        case .top:
            let width = viewSize.width
            let height = imgSize.height / viewSize.width * imgSize.width
            drawRect = CGRect(x: 0, y: 0, width: width, height: height)
        case .center:
            let x = (viewSize.width - imgSize.width) / 2
            let y = (viewSize.height - imgSize.height) / 2
            drawRect = CGRect(x: x, y: y, width: viewSize.width, height: imgSize.height)
        case .bottom:
            let x = viewSize.width - imgSize.width
            let y = viewSize.height - imgSize.height
            drawRect = CGRect(x: x, y: y, width: viewSize.width, height: imgSize.height)
        case .fill:
            drawRect = self.bounds
        case .aspectFill:
            let widthRatio = viewSize.width / imgSize.width
            let heightRatio = viewSize.height / imgSize.height
            let resizeRatio = max(widthRatio, heightRatio)
            
            let width = imgSize.width * resizeRatio
            let height = imgSize.height * resizeRatio
            let x = (viewSize.width - width) / 2
            let y = (viewSize.height - height) / 2
            
            drawRect = CGRect(x: x, y: y, width: width, height: height)
        }
        img.draw(in: drawRect)
        
        // 將結果輸出
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = newImage else { return }
        self.backgroundColor = UIColor(patternImage: image)
    }
    
    enum BgImgContentMode {
        case top
        case center
        case bottom
        case fill
        case aspectFill
    }
}
