//
//  public extension + NSObject.swift
//  comic
//
//  Created by Chiao-Te Ni on 2017/12/7.
//  Copyright © 2017年 Appimc. All rights reserved.
//

import Foundation
import UIKit

extension NSObject: ClassNameProtocol {}

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

public protocol NibInstantiatable {
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
    static var nibOwner: Any? { get }
    static var nibOptions: [AnyHashable: Any]? { get }
    static var instantiateIndex: Int { get }
}

public extension NibInstantiatable where Self: NSObject {
    static var nibName: String { return className }
    static var nibBundle: Bundle { return Bundle(for: self) }
    static var nibOwner: Any? { return self }
    static var nibOptions: [AnyHashable: Any]? { return nil }
    static var instantiateIndex: Int { return 0 }
}

public extension NibInstantiatable where Self: UIView {
    static func instantiate() -> Self? {
        let nib = UINib(nibName: nibName, bundle: nibBundle)
        return nib.instantiate(withOwner: nibOwner, options: nibOptions as? [UINib.OptionsKey : Any])[instantiateIndex] as? Self
    }
}
