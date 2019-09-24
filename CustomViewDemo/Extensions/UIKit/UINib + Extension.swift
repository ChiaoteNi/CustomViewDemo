//
//  Extension + UINib.swift
//  YaitooIM
//
//  Created by admin on 2019/4/8.
//  Copyright © 2019 paradise. All rights reserved.
//

import Foundation
import UIKit

extension UINib {
    static func load(nibName name: String, bundle: Bundle? = nil) -> Any? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first
    }
    
    static func loadView<T: UIView>(class: T.Type) -> T?  {
        let nibName = T.className
        return load(nibName: nibName) as? T
    }
}
