//
//  File.swift
//  BottomTagsBarTest
//
//  Created by Chiao-Te Ni on 2018/3/13.
//  Copyright © 2018年 aaron. All rights reserved.
//  用於 梗文/小說 列表下方的TagsBar

import Foundation
import UIKit

class BottomTagsBar: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BottomTagsBarViewDelegate  {
    
    // 由外部VC指定物件, deinit要放掉
    public weak var delegate: BottomTagsBarDelegate? {
        didSet { updateDefaultValue() }
    }
    public weak var dataSource: BottomTagsBarDataSource? {
        didSet {
            reloadCell {
                guard let index = self.initIndex else { return }
                self.selectCell(at: index)
            }
        }
    }
    public var isHiddenWhenScrollup = true
    public var scrollViewObserve: NSKeyValueObservation?
    
    private weak var _locateRelatedView: UIView?
    private weak var _superViewHeightConstraint: NSLayoutConstraint?
    
    // 內部變數
    private var _tagsBarView: BottomTagsBarView?
    private let _leftAlignFlowLayout = TagsBarLeftAlignLayout()
    private var _originFlowLayout: UICollectionViewFlowLayout?
    // 起始值
    private var initIndex: Int?
    // current值
    private var _panStartPtY: CGFloat           = 0
    private var _currentTagsBarHeight: CGFloat  = 0
    private var _lastSelectedIndex: Int         = 0
    private var _currentIndex: Int              = 0 {
        didSet { _lastSelectedIndex = oldValue }
    }
    // 預設值
    private var _defaultCellSize                    = CGSize(width: 60, height: 28)
    private var _defaultLineSpacing: CGFloat        = 14
    private var _defaultInerItemSpacing: CGFloat    = 8
    private var _defaultInsets                      = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 56)
    private var _defaultSectionInsets               = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private var _maxBarHeight: CGFloat?             = 300 {
        didSet {
            guard _maxBarHeight != oldValue else { return }
            guard _isTagsBarViewOpened else { return }
            updateBarHeightConstraint(constant: _maxBarHeight)
        }
    }
    private var _minBarHeight: CGFloat              = 49
    private var _corRadius: CGFloat?
    private var _defaultSelectedIndex: IndexPath?   = IndexPath(item: 0, section: 0)
    // 狀態判定值
    private var _canShowHorizenArrow: Bool = false
    private var _isTagsBarViewOpened: Bool = false {
        didSet {
            guard _isTagsBarViewOpened != oldValue else { return }
            changeTagsBarOpenState(isOpen: _isTagsBarViewOpened)
        }
    }
    
    // 圖片
    private var _upArrowImg: UIImage!
    private var _downArrowImg: UIImage!
    private var _leftArrowImg: UIImage!
    private var _rightArrowImg: UIImage!
    
    override init() {
        super.init()
        _corRadius = _defaultCellSize.height / 2
        _currentIndex = initIndex ?? _defaultSelectedIndex?.item ?? 0
    }
    
    convenience init(withIndex index: Int) {
        self.init()
        initIndex = index
    }
    
    deinit {
        // 外部給的, 強制釋放掉
        delegate = nil
        dataSource = nil
        _locateRelatedView = nil
        _superViewHeightConstraint = nil
        // 內部設的, 保險起見還是自己釋放掉
        _tagsBarView = nil
        _originFlowLayout = nil
        _maxBarHeight = nil
        _corRadius = nil
    }
    
    public func setControlImages(upImg up:UIImage, downImg down:UIImage, leftImg left:UIImage, rightImg right:UIImage) {
        _upArrowImg = up
        _downArrowImg = down
        _leftArrowImg = left
        _rightArrowImg = right
    }
    
    // MARK: - Public func.
    /// 設定Bar到指定畫面上
    ///
    /// - Parameter superView: 想放置Bar的View
    
    
    /// 設定Bar到指定畫面上
    ///
    /// - Parameters:
    ///   - superView: 想放置Bar的View
    ///   - scrollView: 要監聽的scrollView, 如要滑動縮小TagsBar才需要。如有註冊在deinit要unregister
    public func setupBarView(to superView: UIView, addObserved scrollView: UIScrollView? = nil) {
        _tagsBarView = UINib.loadView(class: BottomTagsBarView.self)
        
        guard let tagsBarView = _tagsBarView else { return }
        tagsBarView.tagsCollectionView.contentInset = _defaultInsets
        tagsBarView._leftArrowImgView.image = _leftArrowImg
        tagsBarView._rightArrowImgView.image = _rightArrowImg
        superView.addSubview(tagsBarView)
        
        _locateRelatedView = superView.superview
        
        _leftAlignFlowLayout.extraBtnSize = tagsBarView.extraControlBtn.frame.size
        
        setColors(with: tagsBarView)
        setContraint(to: tagsBarView, with: superView)
        setupExtraControlBtn(of: tagsBarView)
        setupCollectionView(of: tagsBarView)
        setupLayout()
        
        superView.layoutIfNeeded()
        
        guard let scrollView = scrollView else { return }
        register(scrollView: scrollView)
    }
    
    public func setSafeAreaBottomMask(to superView: UIView) {
        guard #available(iOS 11, *), let inset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
        let view = UIView(frame: superView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .demo_bottomTagBarBG
            
        superView.addSubview(view)
        superView.sendSubviewToBack(view)
        
        view.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: superView.heightAnchor, multiplier: 1, constant: inset).isActive = true
        
        superView.layoutIfNeeded()
    }
    
    public func register(scrollView: UIScrollView) {
        scrollViewObserve = scrollView.observe(\.panGestureRecognizer.state, options:[.new, .old, .initial, .prior]) { scrollView, change in
            guard self._isTagsBarViewOpened else { return }
            guard scrollView.panGestureRecognizer.state == UIGestureRecognizer.State.began else { return }
            self.foldUpBar()
        }
    }
    
    public func unregister() {
        scrollViewObserve?.invalidate()
        scrollViewObserve = nil
    }
    
    public func spreadUpBar() {
        _isTagsBarViewOpened = true
    }
    
    public func foldUpBar() {
        _isTagsBarViewOpened = false
    }
    
    /// reload bar上的cell
    public func reloadCell(completion: (()->Void)? = nil) {
        guard let tagsBarView = _tagsBarView else {
            print("\(#function), but _tagsBarView not exist.")
            completion?()
            return
        }
        guard let cv = tagsBarView.tagsCollectionView else {
            print("\(#function), but tagsCollectionView not exist.")
            completion?()
            return
        }
        cv.reloadData()
        _maxBarHeight = cv.contentSize.height
        
        let width = UIScreen.main.bounds.width
        let contentWidth = cv.collectionViewLayout.collectionViewContentSize.width
        tagsBarView.extraControlBtn.isHidden = contentWidth > width ? false : true
        completion?()
    }
    
    public func selectCell(at index: Int, animated: Bool = true) {
        guard let cv = _tagsBarView?.tagsCollectionView else { return }
        
        _currentIndex = index
        let selectedIndexPath = IndexPath(item: index, section: 0)
        cv.selectItem(at: selectedIndexPath, animated: animated, scrollPosition: [.centeredHorizontally, .centeredVertically])
        cv.reloadData()
    }
    
    public func selectedLastIndex(animated: Bool = true) {
        guard let cv = _tagsBarView?.tagsCollectionView else { return }
        guard let cell = cv.cellForItem(at: IndexPath.init(item: _lastSelectedIndex, section: 0)) as? TagsBarCell else { return }
        selectCell(at: _lastSelectedIndex, animated: animated)
        _lastSelectedIndex = _currentIndex
        delegate?.bottomTagsBar(cv, didSelectItemAt: _lastSelectedIndex, cell: cell)
    }
    
    // MARK: - Setup / Init func.
    private func setupExtraControlBtn(of tagsBarView: BottomTagsBarView) {
        tagsBarView.delegate = self
        tagsBarView.extraControlBtnHeightLayout.constant = _minBarHeight
//        setImg(to: tagsBarView.extraControlBtn, with: _upArrowImg)
    }
    
    private func setupCollectionView(of tagsBarView: BottomTagsBarView) {
        guard let cv = tagsBarView.tagsCollectionView else { return }
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: TagsBarCell.self)
    }
    
    private func setupLayout() {
        _leftAlignFlowLayout.delegate = self
        guard let lauout = _tagsBarView?.tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        _originFlowLayout = lauout
    }
    
    private func setContraint(to view: UIView, with superView: UIView) {
        view.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: superView.heightAnchor, multiplier: 1).isActive = true
        
        for constant in superView.constraints {
            guard constant.firstAttribute == .height else { continue }
            _superViewHeightConstraint = constant
            break
        }
        _superViewHeightConstraint?.constant = _minBarHeight
        _currentTagsBarHeight = _minBarHeight
    }
    
    private func setColors(with tagsBarView: BottomTagsBarView) {
        let color: UIColor = .demo_bottomTagBarBG
        tagsBarView.extraControlBtn.backgroundColor = color.withAlphaComponent(0.9)
        tagsBarView.setColors(toPullBar: color, toCollectionView: color)
    }
    
    // MARK: - Update/Get value func.
    private func updateDefaultValue() {
        guard let delegate = delegate else { return }
        guard let cv = _tagsBarView?.tagsCollectionView else { return }
        let layout = cv.collectionViewLayout
        
        if let delegateLineSpacing = delegate.bottomTagsBar?(cv, layout: layout, minimumLineSpacingForSectionAt: 0) {
            _defaultLineSpacing = delegateLineSpacing
        }
        
        if let delegateInerItemSpacing = delegate.bottomTagsBar?(cv, layout: layout, minimumInteritemSpacingForSectionAt: 0) {
            _defaultInerItemSpacing = delegateInerItemSpacing
        }
    }
    
    private func updateMaxHeightValue(with collectionView: UICollectionView) {
        guard let layout = collectionView.collectionViewLayout as? TagsBarLeftAlignLayout else { return }
        
        var totalLine: CGFloat = 0
        var sectionAmount: CGFloat = 0
        
        for linesInSection in layout.totalLineInSections {
            totalLine += linesInSection
            sectionAmount += 1
        }
        
        let contentHeight = layout.maxY
        _maxBarHeight = contentHeight + collectionView.contentInset.top + collectionView.contentInset.bottom + 10
    }
    
    private func getLastIndexPath() -> IndexPath? {
        guard let cv = _tagsBarView?.tagsCollectionView else { return nil }
        guard let cellAmount = dataSource?.bottomTagsBar(numberOfItemsIn: cv) else { return nil }
        let item = cellAmount - 1
        return IndexPath(item: item, section: 0)
    }
    
    //MARK: - Update UI
    private func updateBarHeightConstraint(constant: CGFloat?, completion: (()->Void)? = nil) {
        guard let constant = constant else { return }
        guard let heightConstraint = _superViewHeightConstraint else { return }
        
        heightConstraint.constant = constant
        UIView.animate(withDuration: 0.25, animations: {
            self._locateRelatedView?.layoutIfNeeded()
        }, completion: { success in
            guard success else { return }
            completion?()
            guard let constraint = self._superViewHeightConstraint else { return }
            self._currentTagsBarHeight = constraint.constant
        })
        
        guard let contentInset = _tagsBarView?.tagsCollectionView.contentInset else { return }
        let height = _leftAlignFlowLayout.maxY + contentInset.top + contentInset.bottom + 10
        guard _maxBarHeight != height else { return }
        _maxBarHeight = height
    }
    
    private func changeTagsBarOpenState(isOpen: Bool) {
        guard let bottomTagsBar = _tagsBarView else { return }
        guard let button = bottomTagsBar.extraControlBtn else { return }
        
        if isOpen {
            setImg(to: button, with: _downArrowImg, withBorder: false)
            // 先換layout再長上去
            bottomTagsBar.tagsCollectionView.collectionViewLayout = _leftAlignFlowLayout
            updateMaxHeightValue(with: bottomTagsBar.tagsCollectionView)
            updateBarHeightConstraint(constant: _maxBarHeight ?? 800 )
        } else if let layout = _originFlowLayout {
            setImg(to: button, with: _upArrowImg)
            // 先縮回去再換layout, 不然alignLeft提早換掉會看到跑版
            updateBarHeightConstraint(constant: _minBarHeight, completion: {
                bottomTagsBar.tagsCollectionView.collectionViewLayout = layout
                // 處理最後一個Tag選擇時縮回去會有部分cell面積被extraBtn遮到的情況
                guard let lastIndex = self.getLastIndexPath() else { return }
                let isLastCellSelected = bottomTagsBar.isItemSelected(AtIndexPath: lastIndex)
                guard isLastCellSelected else { return }
                bottomTagsBar.tagsCollectionView.scrollToItem(at: lastIndex, at: UICollectionView.ScrollPosition.right, animated: true)
            })
        }
        
        guard let cells = bottomTagsBar.tagsCollectionView?.visibleCells as? [TagsBarCell] else { return }
        for cell in cells {
            cell.layer.borderWidth = _isTagsBarViewOpened ? 1 : 0
        }
    }
    
    
    // MARK: - UICollectionViewDataSource func. {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return dataSource?.bottomTagsBar(numberOfItemsIn: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: TagsBarCell.self, for: indexPath) else { return UICollectionViewCell() }
        cell.layer.cornerRadius = _corRadius ?? 0
        cell.layer.borderWidth  = _isTagsBarViewOpened ? 1 : 0
        
        if let selectedIndex = _defaultSelectedIndex, indexPath == selectedIndex {
            cell.isSelected = true
        }
        
        dataSource?.bottomTagsBar(collectionView, cellForItemAt: indexPath.item, cell: cell)
        return cell
    }
    
    //MARK: - UICollectionViewDelegate func.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 初次點擊，起始select index不為0的case
        if let index = initIndex {
            collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isSelected = false
            initIndex = nil
        }
        // 初次點擊，起始select index為0的case
        if let defaultSelectedIndex = _defaultSelectedIndex, indexPath != defaultSelectedIndex {
            collectionView.cellForItem(at: defaultSelectedIndex)?.isSelected = false
            _defaultSelectedIndex = nil
        }
        
        if _currentIndex != indexPath.item, collectionView.cellForItem(at: IndexPath(item: _currentIndex, section: 0))?.isSelected == true {
            collectionView.cellForItem(at: IndexPath(item: _currentIndex, section: 0))?.isSelected = false
        }
        _currentIndex = indexPath.item
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagsBarCell else { return }
        delegate?.bottomTagsBar(collectionView, didSelectItemAt: indexPath.item, cell: cell)
        guard _isTagsBarViewOpened else { return }
        guard let tagBar = _tagsBarView, let btn = tagBar.extraControlBtn else { return }
        bottomTagsBar(tagBar, extraBtnDidSelected: btn)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(with: TagsBarCell.self, for: indexPath) else { return }
        delegate?.bottomTagsBar?(collectionView, didDeselectItemAt: indexPath.item, item: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == _currentIndex {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout func.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = delegate?.bottomTagsBar?(collectionView, layout: collectionViewLayout, widthForItemAt: indexPath.item) ?? _defaultCellSize.width
        width -= 8
        let height = _defaultCellSize.height
        let corSpacing = _corRadius ?? 0
        return CGSize(width: width + (corSpacing * 2), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacing = delegate?.bottomTagsBar?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        return spacing ?? _defaultLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing = delegate?.bottomTagsBar?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        return spacing ?? _defaultInerItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return _isTagsBarViewOpened ? UIEdgeInsets(top: 10, left: -20, bottom: 0, right: 0) : _defaultSectionInsets
    }
    
    //MARK: - UIScrollViewDelegate func.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard isHorizentally(of: scrollView) else { return }
        delegate?.bottomTagsBar?(didScroll: collectionView)
        showHorizenalArrow(with: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _canShowHorizenArrow = true
        showHorizenalArrow(with: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else { return } //如果willDecelerate則交給scrollViewDidEndDecelerating隱藏
        let xVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).x
        guard xVelocity <= 0.5 || xVelocity >= -0.5 else { return }
        hideHorizenalArrow()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideHorizenalArrow()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        delegate?.bottomTagsBar?(didScrollToTop: collectionView)
    }
    
    private func isHorizentally(of scroView: UIScrollView) -> Bool {
        let velocity = scroView.panGestureRecognizer.velocity(in: scroView)
        if velocity.x >= velocity.y * 2 {
            return true
        } else {
            return false
        }
    }
    
    private func showHorizenalArrow(with scrollView: UIScrollView) {
        guard _canShowHorizenArrow else { return }
        guard let tagsBarView = _tagsBarView else { return }
        
        let currentX = scrollView.contentOffset.x
        
        if currentX >= tagsBarView.fadeOutWidth {
            tagsBarView.isLeftArrowHidden = false
        } else {
            tagsBarView.isLeftArrowHidden = true
        }
        
        if currentX + scrollView.frame.width - tagsBarView.fadeOutWidth <= scrollView.contentSize.width {
            tagsBarView.isRightArrowHidden = false
        } else {
            tagsBarView.isRightArrowHidden = true
        }
        
        guard self._tagsBarView?.extraControlBtn.isHidden == false else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            self._tagsBarView?.extraControlBtn.alpha = 0
        }, completion: { _ in
            self._tagsBarView?.extraControlBtn.isHidden = true
        })
    }
    
    private func hideHorizenalArrow() {
        _tagsBarView?.isLeftArrowHidden = true
        _tagsBarView?.isRightArrowHidden = true
        
        _tagsBarView?.extraControlBtn.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self._tagsBarView?.extraControlBtn.alpha = 1
        })
        _canShowHorizenArrow = false // 按掉後擋住, 除非dragging不然不開放顯示, 排除collectionView延展時造成的狀態誤判
    }
    
    // MARK: - BottomTagsBarViewDelegate
    func bottomTagsBar(_ bottomTagsBar: BottomTagsBarView, extraBtnDidSelected button: UIButton) {
        _isTagsBarViewOpened = !_isTagsBarViewOpened
    }
    
    private func setImg(to btn: UIButton, with img: UIImage, withBorder: Bool = true) {
        btn.setImage(img, for: .normal)
        btn.setImage(img, for: .highlighted)
        btn.setImage(img, for: .selected)
        
        let color: UIColor = withBorder ? .demo_border : .demo_bottomTagBarBG
        btn.imageView?.layer.addBorder(edge: .bottom, color: color, thickness: 0.5)
    }
}
