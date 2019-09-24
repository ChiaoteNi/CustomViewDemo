//
//  SegmentDemoVC.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/9.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

enum DemoCase: String, CaseIterable {
    case novel      = "小說"
    case comic      = "漫畫"
    case dictionary = "字典"
    case magazine   = "雜誌"
    case usedBook   = "二手書"
    case tazze      = "讀冊"
}

class SegmentVC: BaseVC {
    
    @IBOutlet private weak var segment: DemoSegment!
    @IBOutlet private weak var indicatorSegment: DemoSegment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegment()
        setupIndicatorSegment()
    }
}

extension SegmentVC {
    
    private func setupSegment() {
        segment
            .indicatorWidth(min: 0, max: 64)
            .color(.demo_segmentIndicator, for: .indicator)
            .color(.demo_segmentTxtFocused, for: .txtFocus)
            .color(.demo_segmentTxt, for: .txt)
            .color(.demo_segmentBG, for: .background)
            .font(.demo_segment)
            .dataSource(DemoCase.allCases.map({ $0.rawValue }))
            .onSegmentDidSelect { index in
                print(DemoCase.allCases[safe: index]?.rawValue ?? "")
        }
    }
    
    private func setupIndicatorSegment() {
        indicatorSegment
            .set(\.isSelectEnable, to: true)
            .cellWidth(min: 96, max: UIScreen.main.bounds.width * 0.256)
            .color(.fn_feedBackSegmentTxt, for: .txtFocus)
            .color(.fn_feedBackSegmentTxt, for: .txt)
            .color(.clear, for: .background)
            .font(.demo_borderSegment)
            .dataSource(DemoCase.allCases.map({ $0.rawValue }))
            .register(cell: BorderSegmentCell.self)
            .onSegmentDidSelect { index in
                print(DemoCase.allCases[safe: index]?.rawValue ?? "")
        }
    }
}

