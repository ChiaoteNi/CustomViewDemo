//
//  UIView + Constraints.swift
//  Fano
//
//  Created by admin on 2019/7/30.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func set(_ anchor: KeyPath<UIView, NSLayoutDimension>, to constant: CGFloat) -> Self {
        setConstraint(anchor, to: constant)
        return self
    }
    
    @discardableResult
    func set<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (_ keyPath: KeyPath<UIView, LayoutType>,
                                                                  equalTo anchor: LayoutType,
                                                                  constant: CGFloat = 0,
                                                                  with multiplier: CGFloat? = nil,
                                                                  priority: UILayoutPriority = .required) -> Self {
        
        setConstraint(keyPath, to: anchor, relatedBy: .equal, constant: constant, with: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    func set<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (_ keyPath: KeyPath<UIView, LayoutType>,
                                                                  greaterThanOrEqual anchor: LayoutType,
                                                                  constant: CGFloat = 0,
                                                                  with multiplier: CGFloat? = nil,
                                                                  priority: UILayoutPriority = .required) -> Self {
        
        setConstraint(keyPath, to: anchor, relatedBy: .greaterThanOrEqual, constant: constant, with: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    func set<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (_ keyPath: KeyPath<UIView, LayoutType>,
                                                                  lessThanOrEqual anchor: LayoutType,
                                                                  constant: CGFloat = 0,
                                                                  with multiplier: CGFloat? = nil,
                                                                  priority: UILayoutPriority = .required) -> Self {
        
        setConstraint(keyPath, to: anchor, relatedBy: .lessThanOrEqual, constant: constant, with: multiplier, priority: priority)
        return self
    }


    
    @discardableResult
    func set<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (_ keyPath: KeyPath<UIView, LayoutType>,
                                                                  to anchor: LayoutType,
                                                                  relatedBy relation: NSLayoutConstraint.Relation = .equal,
                                                                  constant: CGFloat = 0,
                                                                  with multiplier: CGFloat? = nil,
                                                                  priority: UILayoutPriority = .required) -> Self {
        
        setConstraint(keyPath, to: anchor, relatedBy: relation, constant: constant, with: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    func setConstraint(_ anchor: KeyPath<UIView, NSLayoutDimension>,
                       to constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint = self[keyPath: anchor].constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setConstraint<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (_ keyPath: KeyPath<UIView, LayoutType>,
                                                                            to anchor: LayoutType,
                                                                            relatedBy relation: NSLayoutConstraint.Relation = .equal,
                                                                            constant: CGFloat = 0,
                                                                            with multiplier: CGFloat? = nil,
                                                                            priority: UILayoutPriority) -> NSLayoutConstraint {
        // multiplier
        // Anchor = NSLayoutDimesion (for multiplier)
        if let multiplier = multiplier,
            let dimension = self[keyPath: keyPath] as? NSLayoutDimension,
            let anchor = anchor as? NSLayoutDimension {
            
            let constraint: NSLayoutConstraint
            switch relation {
            case .equal:
                constraint = dimension.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = dimension.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = dimension.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            @unknown default:
                constraint = dimension.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            }
            
            constraint.priority = priority
            constraint.isActive = true
            return constraint
            
        } else {
            // no multiplier
            // Anchor = Anchor / NSLayoutDimesion
            let constraint: NSLayoutConstraint
            switch relation {
            case .equal:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
            @unknown default:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            }
            
            constraint.priority = priority
            constraint.isActive = true
            return constraint
        }
        
    }
}
