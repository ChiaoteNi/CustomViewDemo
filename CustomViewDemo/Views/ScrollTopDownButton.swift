//
//  ScrollTopDownButton.swift
//  ck101
//
//  Created by Chiao-Te Ni on 2018/3/26.
//  Copyright © 2018年 Webber. All rights reserved.
//

import UIKit

protocol ScrollTopBtnDelegate: class {
    func scrollTopBtn(didSelected btn: ScrollTopDownButton)
    func scrollTopBtn(_ btn: ScrollTopDownButton, shouldScrollToTopFor scrollView: UIScrollView) -> Bool
}

extension ScrollTopBtnDelegate {
    func scrollTopBtn(_ btn: ScrollTopDownButton, shouldScrollToTopFor scrollView: UIScrollView) -> Bool { return true }
}

class ScrollTopDownButton: NSObject {
    
    weak var delegate: ScrollTopBtnDelegate?
    
    private var _btn: UIView?
    private var _img: UIImageView?
    private var _label: UILabel?
    
    private weak var observed: UIScrollView?
    @objc dynamic var abserveKey = "contentOffset"
    
    private var isToTop: Bool = false {
        didSet { resetBtnContent() }
    }
    
    deinit {
        guard let observed = observed else { return }
        observed.removeObserver(self, forKeyPath: abserveKey)
        self.observed = nil
    }
    
    func btnHidden(_ hide:Bool) {
        _btn?.isHidden = hide
    }
    
    // Setup & Init func.
    func setupBtn(to vc: UIViewController, belowSubView: UIView?, observed: UIScrollView) {
        initBtnView(with: vc.view)
        guard let btn = _btn else { return }
        if let belowSubView = belowSubView {
            vc.view.insertSubview(btn, belowSubview: belowSubView)
        } else {
            vc.view.addSubview(btn)
        }
        
        initImg(with: btn)
        initLabel(with: btn)
        resetBtnContent()
        
        register(observed: observed)
    }
    
    func register(observed: UIScrollView) {
        self.observed = observed
        observed.addObserver(self, forKeyPath: abserveKey, options: [.initial,.new], context: nil)
    }
    
    func unregister() {
        observed?.removeObserver(self, forKeyPath: abserveKey)
        observed = nil
    }
    
    private func initBtnView(with view: UIView) {
        // init
        let length = UIScreen.main.bounds.height * 46 / 667
        let size = CGSize(width: length, height: length)
        let origin = CGPoint(x: UIScreen.main.bounds.width - length,
                             y: UIScreen.main.bounds.height * 532 / 667) // 532 & 667均為設計稿數值
        _btn = UIView(frame: CGRect(origin: origin, size: size))
        
        // setup
        _btn?.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        _btn?.layer.cornerRadius = 3
        _btn?.layer.borderColor = UIColor.demo_scrollTopDownBorder.cgColor
        _btn?.layer.borderWidth = 0.5
        
        // setGesture
        let gesture = UITapGestureRecognizer(target: self, action: #selector(btnPressed))
        _btn?.addGestureRecognizer(gesture)
    }
    
    private func initImg(with view: UIView) {
        // init
        let superViewWidth = view.bounds.width
        let length = superViewWidth / 4
        let origin = CGPoint(x: (superViewWidth - length) / 2,
                             y: view.bounds.height / 2 - length)
        let size = CGSize(width: length, height: length)
        _img = UIImageView(frame: CGRect(origin: origin, size: size))
        _img?.image = #imageLiteral(resourceName: "ScrollToTopDown")
        guard let img = _img else { return }
        view.addSubview(img)
    }
    
    private func initLabel(with view: UIView) {
        // init
        let superViewWidth = view.bounds.width
        let length = superViewWidth / 2
        let origin = CGPoint(x: (superViewWidth - length) / 2,
                             y: view.bounds.height - length)
        let size = CGSize(width: view.bounds.width, height: 11)
        _label = UILabel(frame: CGRect(origin: origin, size: size))
        guard let label = _label else { return }
        view.addSubview(label)
        
        // setup
        label.center = CGPoint(x: view.bounds.width / 2,
                               y: view.bounds.height * 0.75)
        label.textAlignment = .center
        label.font = .demo_scrollDownBtn
        label.textColor = .demo_scrollTopDownText
        
        label.text = "頁首"
    }
    
    private func resetBtnImg() {
        _btn?.setBackgroundImage(with: #imageLiteral(resourceName: "ScrollToTopDown"), withContentType: .fill, backgroundColor: .clear)
    }
    
    private func resetBtnContent() {
        let alpha: CGFloat = isToTop ? 1 : 0
        UIView.animate(withDuration: 0.12) {
            self._btn?.alpha = alpha
            self._img?.alpha = alpha
            self._label?.alpha = alpha
        }
    }

    // 點擊的行為
    @objc private func btnPressed() {
        delegate?.scrollTopBtn(didSelected: self)
        guard let observed = observed else { return }
        guard delegate?.scrollTopBtn(self, shouldScrollToTopFor: observed) != false else { return }
        scroll(with: observed)
    }
    
    private func scroll(with scrollView: UIScrollView) {
        let pt: CGPoint
        if isToTop {
            pt = CGPoint(x: scrollView.contentInset.left, y: 0 - scrollView.contentInset.top)
        } else {
            pt = CGPoint(x: scrollView.contentInset.left, y: scrollView.contentSize.height - scrollView.frame.size.height)
        }
        scrollView.setContentOffset(pt, animated: true)
    }
    
    // 監聽scrollView滑動
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
        let newIsToTopValue: Bool
        if offset.y <= 0 - (observed?.contentInset.top ?? 0) {
            newIsToTopValue = false
        } else {
            newIsToTopValue = true
        }
        guard isToTop != newIsToTopValue else { return }
        isToTop = newIsToTopValue
        resetBtnContent()
    }
}
