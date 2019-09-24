//
//  public extension + UITableView.swift
//  comic
//
//  Created by Chiao-Te Ni on 2017/12/7.
//  Copyright © 2017年 Appimc. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func register<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        let className = viewType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T
    }
    
    // 可能大量快速呼叫, 不想多判一個boolean, 直接與上面分開func
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.className) as? T
    }
    
    func getCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(with: type, for: indexPath) ?? T()
    }
    
    func getCell<T: UITableViewCell>(with type: T.Type) -> T {
        return dequeueReusableCell(with: type) ?? T()
    }
    
    func dequeueReusableView<T: UIView>(with type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: type.className) as? T
    }
}

