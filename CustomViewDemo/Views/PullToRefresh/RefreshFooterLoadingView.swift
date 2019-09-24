//
//  RefreshFooterLoadingView.swift
//  Fano
//
//  Created by admin on 2019/8/2.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

final class RefreshFooterLoadingView: UIView, PullRefreshContentViewSpec {
    
    private var indicator: UIActivityIndicatorView = .init(style: .gray)
    private var titleLabel: UILabel = .init()
    
    init(_ frame: CGRect = .zero) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func startLoading() {
        print("View \(#function)")
        indicator.startAnimating()
    }
    
    func endLoading() {
        print("View \(#function)")
        indicator.stopAnimating()
    }
    
    func invalidate() {
        print("View \(#function)")
        indicator.stopAnimating()
    }
}

extension RefreshFooterLoadingView {
    private func initSetup() {
        indicator.startAnimating()
        indicator
            .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
            .set(\.widthAnchor, to: 30)
            .set(\.heightAnchor, to: 30)
        titleLabel
            .set(\.text, to: "上拉读取更多")
            .set(\.font, to: .demo_refreshFooterTitle)
            .set(\.textColor, to: .demo_refreshFooterTitle)
        
        let stackView: UIStackView = .init(arrangedSubviews: [indicator, titleLabel])
        addSubview(stackView)
        stackView
            .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
            .set(\.alignment, to: .fill)
            .set(\.axis, to: .horizontal)
            .set(\.distribution, to: .fillProportionally)
            .set(\.spacing, to: 8)
            // constraints
            .set(\.centerYAnchor, equalTo: centerYAnchor)
            .set(\.centerXAnchor, equalTo: centerXAnchor)
            .set(\.centerXAnchor, equalTo: centerXAnchor)
            .set(\.heightAnchor, equalTo: heightAnchor, with: 0.7)
    }
}


