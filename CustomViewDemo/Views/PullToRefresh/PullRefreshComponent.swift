//
//  BasePullRefreshComponent.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/9.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

protocol PullRefreshContentViewSpec: UIView {
    func startLoading()
    func endLoading()
    func invalidate()
}

class BasePullRefreshComponent: UIView {
    
    //MARK: - 共通部分
    typealias ContentLoadingView = PullRefreshContentViewSpec
    
    fileprivate weak var scrollView: UIScrollView!
    fileprivate var originInset: CGFloat?
    fileprivate var scrollViewObserve: NSKeyValueObservation?
    fileprivate var boundsObserve: NSKeyValueObservation?
    fileprivate var startRefreshTime: Date?
    
    fileprivate weak var contentLoadingView: ContentLoadingView?
    fileprivate var refreshAction: (()->Void)?
    
    fileprivate var componentHeight: CGFloat = 0
    
    fileprivate var targetInset: ReferenceWritableKeyPath<BasePullRefreshComponent, CGFloat>? {
        return nil
    }
    
    var canRefresh: Bool = true
    
    override var frame: CGRect {
        didSet {
            bounds.size = frame.size
            contentLoadingView?.frame = bounds
        }
    }
    
    init(in frame: CGRect = CGRect.init(x: 0, y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: 50),
         with loadingView: PullRefreshContentViewSpec) {
        
        super.init(frame: frame)
        componentHeight = frame.size.height
        
        loadingView.frame = bounds
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        contentLoadingView = loadingView
        
        loadingView
            .set(\.topAnchor, equalTo: topAnchor)
            .set(\.bottomAnchor, equalTo: bottomAnchor)
            .set(\.leadingAnchor, equalTo: leadingAnchor)
            .set(\.trailingAnchor, equalTo: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assert(false, "Not support GUI layout.")
    }
    
    deinit {
        contentLoadingView?.invalidate()
        contentLoadingView?.removeFromSuperview()
        contentLoadingView = nil
        scrollViewObserve?.invalidate()
        scrollViewObserve = nil
    }
    
    func unregister() {
        endRefresh()
        removeFromSuperview()
        scrollViewObserve?.invalidate()
        boundsObserve?.invalidate()
        originInset = nil
        scrollView = nil
    }
    
    func invalidate() {
        contentLoadingView?.invalidate()
        scrollViewObserve?.invalidate()
        scrollViewObserve = nil
        boundsObserve?.invalidate()
        boundsObserve = nil
    }
    
    //MARK: - 需實作不同部分
    @discardableResult
    func register(on scrollView: UIScrollView) -> Self {
        return self
    }
    
    @discardableResult
    func setRefreshAction(action: @escaping ()->Void) -> Self {
        refreshAction = action
        return self
    }
    
    @discardableResult
    func endRefresh(completion: (()->Void)? = nil) -> Self {
        guard startRefreshTime != nil else { return self }
        guard let inset = targetInset else { return self }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: {
            self[keyPath: inset] = -self.componentHeight
        }, completion: { [weak self] complete in
            guard let self = self else { return }
            if complete == false {
                self[keyPath: inset] = 0
            } else {
                self.contentLoadingView?.endLoading()
                self.startRefreshTime = nil
                completion?()
            }
        })
        return self
    }
    
    fileprivate func startRefresh() {
        guard canRefresh else {
            endRefresh()
            return
        }
        contentLoadingView?.startLoading()
        
        guard let scrollView = scrollView else { return }
        let state = scrollView.panGestureRecognizer.state
        guard state == .ended || state == .possible else { return }
        
        guard startRefreshTime == nil else { return }
        startRefreshTime = Date()
        
        guard let targetInset = targetInset else {
            refreshAction?()
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
                self[keyPath: targetInset] = 0
            }, completion: { [weak self] _ in
                self?.refreshAction?()
        })
    }
}

///=========================
//MARK: - RefreshHeader
///=========================
final class PullRefreshHeader: BasePullRefreshComponent {
    
    override var targetInset: ReferenceWritableKeyPath<BasePullRefreshComponent, CGFloat>? {
        return \BasePullRefreshComponent.scrollView.contentInset.top
    }
    
    @discardableResult
    override func register(on scrollView: UIScrollView) -> Self {
        unregister()
        isHidden = false
        
        originInset = scrollView.contentInset.bottom
        scrollView.contentInset.top = -componentHeight
        
        if let tableView = scrollView as? UITableView {
            tableView.tableHeaderView = self
        } else {
            scrollView.addSubview(self)
        }
        
        self.scrollView = scrollView
        
        scrollViewObserve = scrollView.panGestureRecognizer
            .observe(\.state, options:[.prior, .new, .old]) { [weak self, weak scrollView] gesture, _ in
                guard let self = self else { return }
                guard let scrollView = scrollView else { return }
                
                switch gesture.state {
                case .ended, .possible:
                    let offset = scrollView.contentOffset.y
                    guard offset < 0 else { return }
                    self.startRefresh()
                default: break
                }
        }
        return self
    }
}

///=========================
// MARK: - RefreshFooter
///=========================
final class PullRefreshFooter: BasePullRefreshComponent {
    
    override var targetInset: ReferenceWritableKeyPath<BasePullRefreshComponent, CGFloat>? {
        return \BasePullRefreshComponent.scrollView.contentInset.bottom
    }
    
    @discardableResult
    override func register(on scrollView: UIScrollView) -> Self {
        unregister()
        isHidden = false
        
        originInset = scrollView.contentInset.bottom
        scrollView.contentInset.bottom = -componentHeight
        if let tableView = scrollView as? UITableView {
            tableView.tableFooterView = self
        }
        
        self.scrollView = scrollView
        
        scrollViewObserve = scrollView.panGestureRecognizer
            .observe(\.state, options:[.prior, .new, .old]) { [weak self, weak scrollView] gesture, _ in
                guard let self = self else { return }
                guard let scrollView = scrollView else { return }
                
                switch gesture.state {
                case .ended, .possible:
                    let fullPageContentOffsetY = (scrollView.contentSize.height - scrollView.frame.height)
                    let offset = scrollView.contentOffset.y
                    guard offset >= fullPageContentOffsetY else { return }
                    self.startRefresh()
                default: break
                }
        }
        
        return self
    }
}
