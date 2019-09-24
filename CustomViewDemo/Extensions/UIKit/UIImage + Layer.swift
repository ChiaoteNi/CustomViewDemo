//
//  UIImage + Layer.swift
//  LayoutWithCoreText
//
//  Created by aaronni on 2019/7/29.
//  Copyright © 2019 iOS@Taipei. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(layer: CALayer) {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque,
                                               UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: image)
    }
}
