//
//  BottomTagsBarViewProtocol.swift
//  ck101
//
//  Created by Chiao-Te Ni on 2018/3/27.
//  Copyright © 2018年 Webber. All rights reserved.
//

import UIKit

protocol BottomTagsBarViewDelegate: class {
    func bottomTagsBar(_ bottomTagsBar: BottomTagsBarView, extraBtnDidSelected button: UIButton)
}
