//
//  UIView + Builder.swift
//  Fano
//
//  Created by admin on 2019/8/7.
//  Copyright © 2019 paradise. All rights reserved.
//

import Foundation

protocol Buildable: AnyObject { }

extension Buildable {
    
    @discardableResult
    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}

extension NSObject: Buildable { }
