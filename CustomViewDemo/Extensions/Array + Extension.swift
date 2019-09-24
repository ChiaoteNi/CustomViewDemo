//
//  public extension + Array.swift
//  comic
//
//  Created by Chiao-Te Ni on 2017/12/7.
//  Copyright © 2017年 Appimc. All rights reserved.
//

import Foundation

public extension Array {
    typealias E = Element
    
    mutating func removeElements(of indexes: [Int]) {
        guard indexes.isEmpty == false else { return }
        for i in 0 ..< indexes.count {
            let removeIndex = indexes[indexes.count - 1 - i]
            guard removeIndex < count else { continue }
            remove(at: removeIndex)
        }
    }
    
    subscript(safe index: Int) -> E? {
        guard index >= 0, index < count else { return nil }
        let element = self[index]
        return element
    }
}

public extension Array where Element: Hashable {
    
    func diff(_ other: [E]) -> [E] {
        let all = self + other
        var counter: [E: Int] = [:]
        all.forEach { counter[$0] = (counter[$0] ?? 0) + 1 }
        return all.filter { (counter[$0] ?? 0) == 1 }
    }
}
