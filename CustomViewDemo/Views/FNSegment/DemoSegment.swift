//
//  FNSegment.swift
//  Fano
//
//  Created by admin on 2019/7/9.
//  Copyright © 2019 paradise. All rights reserved.
//

import UIKit

final class DemoSegment: UIView {
    
    enum ViewColorType {
        case background, indicator, txt, txtFocus
    }
    
    typealias CallBack = (_ index: Int) -> Void
    
    private var indicatorBar: UIView = .init(frame: .zero)
    private var collectionView: UICollectionView!
    private var dataSource: [String] = []
    
    private var minWidth: CGFloat = 0
    private var maxWidth: CGFloat = UIScreen.main.bounds.width
    private var minIndicatorWidth: CGFloat = 0
    private var maxIndicatorWidth: CGFloat = UIScreen.main.bounds.width
    private var indicatorBarHeight: CGFloat = 2
    
    private var segmentFont: UIFont             = .systemFont(ofSize: 12)
    private var segmentBGColor: UIColor         = .white
    private var segmentTxtColor: UIColor        = .black
    private var segmentTxtFocusColor: UIColor   = .black
    private var onSegmentSelectCallBack: CallBack?
    
    private var cellType: SegmentCell.Type = SegmentCell.self {
        didSet { collectionView?.register(cellType: cellType.self) }
    }
    
    private(set) var currentIndex: Int!
    
    var isSelectEnable: Bool = true
    var isIndicatorHidden: Bool = false {
        didSet { indicatorBar.isHidden = isIndicatorHidden }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard indicatorBar.frame.width == 0 else { return }
        initIndicator()
        collectionView.reloadData()
    }
    
    @discardableResult
    func register(cell: SegmentCell.Type) -> Self {
        cellType = cell
        collectionView.reloadData()
        return self
    }
}

// MARK: - Private func.
extension DemoSegment {
    
    private func initSetup() {
        initCollectionView()
        setConstraints()
    }
    
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(cellType: cellType.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func initIndicator() {
        if currentIndex == nil { currentIndex = 0 }
        indicatorBar.removeFromSuperview()
        collectionView.addSubview(indicatorBar)
        indicatorBar.layer.cornerRadius = indicatorBarHeight / 2
        indicatorBar.layer.masksToBounds = true
        setFocusSegmentIndex(to: currentIndex, animated: false)
    }
}

//MARK: - External funcs.
extension DemoSegment {
    
    func setFocusSegmentIndex(to index: Int, animated: Bool = true) {
        guard currentIndex != nil else {
            currentIndex = index
            return
        }
        (collectionView.visibleCells as? [SegmentCell])?.forEach({ $0.isFocus = false })
        
        let indexPath = IndexPath(item: index, section: 0)
        guard let focusCell = collectionView.cellForItem(at: indexPath) else { return }
        (focusCell as? SegmentCell)?.isFocus = true
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = index
        
        guard let attribute = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let frame = attribute.frame
        collectionView.bringSubviewToFront(indicatorBar)
        
        let indicatorWidth = min(max(frame.width * 0.8, minIndicatorWidth), maxIndicatorWidth)
        let indicatorHeight = indicatorBarHeight
        let x = frame.minX + (frame.width - indicatorWidth)/2
        let y = frame.maxY - indicatorHeight
        
        currentIndex = index
        collectionView.reloadData()
        
        guard animated else {
            indicatorBar.frame = CGRect(x: x, y: y, width: indicatorWidth, height: indicatorHeight)
            return
        }
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseIn, animations: {
            self.indicatorBar.frame = CGRect(x: x, y: y, width: indicatorWidth, height: indicatorHeight)
        }, completion: { complete in
            guard complete else { return }
            self.layoutIfNeeded()
        })
    }
}

// MARK: - CollectionView DataSource & Delegate funcs.
extension DemoSegment: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(with: cellType.self, for: indexPath)
        cell.titleLabel.textColor = indexPath.item == (currentIndex ?? 0) ? segmentTxtFocusColor : segmentTxtColor
        cell.titleLabel.font = segmentFont
        
        cell.isFocus = indexPath.item == currentIndex
        
        guard let title = dataSource[safe: indexPath.item] else { return cell }
        cell.titleLabel.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isSelectEnable else { return }
        onSegmentSelectCallBack?(indexPath.item)
        setFocusSegmentIndex(to: indexPath.item)
    }
}

extension DemoSegment: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let contentWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let width = min(max(minWidth, contentWidth / CGFloat(dataSource.count)), maxWidth)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Builder pattern func.
extension DemoSegment {
    
    @discardableResult
    func cellWidth(min: CGFloat, max: CGFloat) -> DemoSegment {
        minWidth = min
        maxWidth = max
        collectionView?.reloadData()
        return self
    }
    
    @discardableResult
    func indicatorWidth(min: CGFloat, max: CGFloat) -> DemoSegment {
        minIndicatorWidth = min
        maxIndicatorWidth = max
        guard indicatorBar.superview != nil else { return self }
        initIndicator()
        return self
    }
    
    @discardableResult
    func dataSource(_ titleArr: [String]) -> DemoSegment {
        dataSource = titleArr
        collectionView.reloadData()
        return self
    }
    
    @discardableResult
    func color(_ color: UIColor, for type: ViewColorType) -> DemoSegment {
        switch type {
        case .txt:
            segmentTxtColor = color
        case .txtFocus:
            segmentTxtFocusColor = color
        case .background:
            collectionView.backgroundColor = color
        case .indicator:
            indicatorBar.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> DemoSegment {
        segmentFont = font
        return self
    }
    
    @discardableResult
    func onSegmentDidSelect(_ callBack: @escaping CallBack) -> DemoSegment {
        onSegmentSelectCallBack = callBack
        return self
    }
}
