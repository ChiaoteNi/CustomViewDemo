//
//  BottomTagsBarView.swift
//  BottomTagsBarTest
//
//  Created by Chiao-Te Ni on 2018/3/13.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class BottomTagsBarView: UIView {
//    @IBOutlet weak var pullBarView: UIView!
//    @IBOutlet var pullTabViews: [UIView]!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var extraControlBtn: UIButton!
    @IBOutlet weak var extraControlBtnHeightLayout: NSLayoutConstraint!
    
    @IBOutlet private weak var _topSeperatorLine: UIView!
    @IBOutlet private weak var _topLineHeightLayout: NSLayoutConstraint!
    
    @IBOutlet private weak var _leftArrowView: UIView!
    @IBOutlet private weak var _rightArrowView: UIView!
    @IBOutlet weak var _leftArrowImgView: UIImageView!
    @IBOutlet weak var _rightArrowImgView: UIImageView!
    
    @IBOutlet private weak var _rightArrowWidthLayout: NSLayoutConstraint!
    @IBOutlet private weak var _leftArrowWidthLayout: NSLayoutConstraint!
    
    // 共外界抓決定什麼時候顯示/隱藏fadeOutView
    private(set) public var fadeOutWidth: CGFloat = 24
    
    var isLeftArrowHidden: Bool = true {
        didSet { arrowHiddenStateChanged(_leftArrowView, isHidden: isLeftArrowHidden) }
    }
    var isRightArrowHidden: Bool = true {
        didSet { arrowHiddenStateChanged(_rightArrowView, isHidden: isRightArrowHidden) }
    }
    
    var delegate: BottomTagsBarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        for subView in self.subviews {
            subView.translatesAutoresizingMaskIntoConstraints = false
            for sndOrderSubView in subView.subviews {
                sndOrderSubView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        _leftArrowWidthLayout.constant = fadeOutWidth
        _rightArrowWidthLayout.constant = fadeOutWidth
        isLeftArrowHidden = true
        isRightArrowHidden = true
        
        if UIScreen.main.scale >= 3 {
            _topLineHeightLayout.constant = 0.2
        } else {
            _topLineHeightLayout.constant = 0.25
            _topSeperatorLine.alpha = 0.6
        }
    }
    
    deinit {
        delegate = nil
    }
    
    @IBAction private func extraControlBtnPressed(_ sender: UIButton) {
        delegate?.bottomTagsBar(self, extraBtnDidSelected: sender)
    }
    
    func setColors(toPullBar: UIColor, toCollectionView: UIColor) {
        tagsCollectionView.backgroundColor = toCollectionView
        
        let mainColor = toCollectionView.cgColor
        let clearColor = UIColor.white.withAlphaComponent(0).cgColor // 直接用clear在gradient繪製時會轉化為深灰色
        
        _leftArrowView.backgroundColor = .clear
        _leftArrowView.layer.setGradientBGColor(colors: [mainColor, clearColor],
                                               locations: [0.4, 1],
                                               direction: .horizental)
        _rightArrowView.backgroundColor = .clear
        _rightArrowView.layer.setGradientBGColor(colors: [clearColor, mainColor],
                                                locations: [0, 0.6],
                                                direction: .horizental)
    }
    
    func isItemSelected(AtIndexPath indexPath: IndexPath) -> Bool {
        guard let cell = tagsCollectionView.cellForItem(at: indexPath) else { return false }
        return cell.isSelected
    }
    
    private func arrowHiddenStateChanged(_ arrowView: UIView, isHidden: Bool) {
        guard arrowView.isHidden != isHidden else { return }
        if isHidden {
            hideArrowView(with: arrowView)
        } else {
            showArrowView(with: arrowView)
        }
    }
    
    private func showArrowView(with arrowView: UIView) {
        arrowView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            arrowView.alpha = 1
        })
    }
    
    private func hideArrowView(with arrowView: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            arrowView.alpha = 0
        }, completion: { _ in
            arrowView.isHidden = true
        })
    }
}
