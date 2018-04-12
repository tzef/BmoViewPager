//
//  BmoPageItemList.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/2.
//
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
protocol BmoPageItemListDelegate: class {
    func bmoViewPageItemList(_ itemList: BmoPageItemList, didSelectItemAt index: Int)
}
class BmoPageItemList: UIView, UICollectionViewDelegate, UICollectionViewDataSource, BmoPageItemListLayoutDelegate {
    var collectionView: UICollectionView? = nil
    let collectionLayout = BmoPageItemListLayout(orientation: .horizontal, direction: .leftToRight)
    
    weak var bmoViewPager: BmoViewPager?
    weak var bmoDelegate: BmoPageItemListDelegate?
    weak var bmoDataSource: BmoViewPagerDataSource?
    weak var bmoViewPgaerNavigationBar: BmoViewPagerNavigationBar?
    var focusCell, nextCell, previousCell: BmoPageItemCell?
    var bmoViewPagerCount = 0
    
    // for calcualte string size
    var calculateSizeLabel = UILabel()
    
    // for auto focus
    var autoFocus = true
    var collectionOffSet: CGFloat = 0
    var previousDistance: CGFloat = 0
    var nextDistance: CGFloat = 0
    var lastProgress: CGFloat = 0
    var previousIndex = -1
    var focusIndex = -1
    var nextIndex = -1
    
    // for interpolation
    let percentageLayer = PercentageLayer()
    
    // for userInterfaceLayoutDirection direction
    var layoutDirection = UIUserInterfaceLayoutDirection.leftToRight
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, delegate: BmoPageItemListDelegate) {
        self.init()
        self.bmoDelegate = delegate
        self.bmoViewPager = viewPager
        self.bmoViewPgaerNavigationBar = navigationBar
        self.backgroundColor = .white
        self.layer.addSublayer(percentageLayer)
    }
    override var bounds: CGRect {
        didSet {
            if oldValue != bounds {
                collectionLayout.layoutChanged = true
            }
        }
    }
    func setCollectionView() {
        collectionLayout.delegate = self
        if bmoViewPgaerNavigationBar?.orientation == .vertical {
            collectionLayout.orientation = .vertical
        }
        if #available(iOS 9.0, *) {
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                collectionLayout.direction = .rightToLeft
                layoutDirection = .rightToLeft
            }
        }
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout)
        collectionView!.register(BmoPageItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.backgroundColor = .clear
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        self.addSubview(collectionView!)
        collectionView!.bmoVP.autoFit(self)
    }
    
    // MARK: - Public
    func reloadData() {
        guard let bmoViewPager = bmoViewPager else {
            bmoViewPagerCount = 0
            return
        }
        bmoViewPagerCount = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 0
        if collectionView == nil {
            self.setCollectionView()
        }
        collectionView?.reloadData()
        if autoFocus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.focusToTargetItem()
            }
        }
    }
    func focusToTargetItem() {
        self.bmoPageItemListLayoutAttributesChanged(collectionLayout.attributesList, animated: true)
    }
    func focusFrom(index: Int) {
        guard let viewPager = bmoViewPager else {
            return
        }
        var progress: CGFloat = 0.0
        percentageLayer.percentage = 0.0
        percentageLayer.displayDo = { [weak self] (percentage) in
            let interpolation = Int(percentage)
            progress = percentage - CGFloat(interpolation)
            if self?.layoutDirection == .rightToLeft && viewPager.orientation == .horizontal {
                progress *= -1
            }
            self?.updateFocusProgress(&progress, index: index + interpolation, enabledAutoFocusIfNeed: false)
            if index < viewPager.presentedPageIndex {
                if percentage == 1.0 * CGFloat(viewPager.presentedPageIndex - index) {
                    self?.percentageLayer.displayDo = nil
                    self?.reloadData()
                }
            }
            if index > viewPager.presentedPageIndex {
                if percentage == -1.0 * CGFloat(index - viewPager.presentedPageIndex) {
                    self?.percentageLayer.displayDo = nil
                    self?.reloadData()
                }
            }
        }
        if viewPager.presentedPageIndex > index {
            percentageLayer.percentage = 1.0 * CGFloat(viewPager.presentedPageIndex - index)
        } else if viewPager.presentedPageIndex < index {
            percentageLayer.percentage = -1.0 * CGFloat(index - viewPager.presentedPageIndex)
        } else {
            self.reloadData()
        }
    }
    func updateFocusProgress(_ progress: inout CGFloat, index: Int, enabledAutoFocusIfNeed: Bool = true) {
        guard let collectionView = collectionView, let viewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return
        }
        if collectionLayout.attributesList.count == 0 {
            return
        }
        if self.layoutDirection == .rightToLeft && viewPager.orientation == .horizontal {
            progress *= -1
        }
        if focusIndex != index {
            focusIndex = index
            if navigationBar.orientation == .horizontal {
                collectionOffSet = collectionView.contentOffset.x
            } else {
                collectionOffSet = collectionView.contentOffset.y
            }
            focusCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? BmoPageItemCell
            if index < bmoViewPagerCount - 1 {
                nextIndex = index + 1
                nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)) as? BmoPageItemCell
            } else {
                if viewPager.infinitScroll {
                    nextIndex = 0
                    nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)) as? BmoPageItemCell
                } else {
                    nextCell = nil
                }
            }
            if index > 0 {
                previousIndex = index - 1
                previousCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as? BmoPageItemCell
            } else {
                if viewPager.infinitScroll {
                    previousIndex = bmoViewPagerCount - 1
                    previousCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as? BmoPageItemCell
                } else {
                    previousCell = nil
                }
            }
            
            var positionNextIndex = nextIndex
            var positionPreviousIndex = previousIndex
            if self.layoutDirection == .rightToLeft && bmoViewPgaerNavigationBar?.orientation == .horizontal {
                positionNextIndex = (bmoViewPagerCount - 1) - nextIndex
                positionPreviousIndex = (bmoViewPagerCount - 1) - previousIndex
            }
            if let nextAttribute = collectionLayout.attributesList[safe: positionNextIndex] {
                if navigationBar.orientation == .horizontal {
                    nextDistance = nextAttribute.center.x - collectionView.center.x - collectionOffSet
                } else {
                    nextDistance = nextAttribute.center.y - collectionView.center.y - collectionOffSet
                }
            }
            if let previousAttribute = collectionLayout.attributesList[safe: positionPreviousIndex] {
                if navigationBar.orientation == .horizontal {
                    previousDistance = collectionView.center.x + collectionOffSet - previousAttribute.center.x
                } else {
                    previousDistance = collectionView.center.y + collectionOffSet - previousAttribute.center.y
                }
            }
            previousCell?.titleLabel.maskProgress = 0.0
            focusCell?.titleLabel.maskProgress = 1.0
            nextCell?.titleLabel.maskProgress = 0.0
        } else {
            nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)) as? BmoPageItemCell
            focusCell = collectionView.cellForItem(at: IndexPath(row: focusIndex, section: 0)) as? BmoPageItemCell
            previousCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as? BmoPageItemCell
            if progress >= 1.0 || progress <= -1.0 {
                progress = lastProgress
            }
            if autoFocus && enabledAutoFocusIfNeed {
                var willSetOffSet: CGFloat = collectionOffSet
                if progress > 0 {
                    willSetOffSet += nextDistance * progress
                } else if progress < 0 {
                    willSetOffSet += previousDistance * progress
                }
                if navigationBar.orientation == .horizontal {
                    if willSetOffSet > collectionView.contentSize.width - collectionView.bounds.width {
                        willSetOffSet = collectionView.contentSize.width - collectionView.bounds.width
                    }
                } else {
                    if willSetOffSet > collectionView.contentSize.height - collectionView.bounds.height {
                        willSetOffSet = collectionView.contentSize.height - collectionView.bounds.height
                    }
                }
                if willSetOffSet < 0 {
                    willSetOffSet = 0
                }
                if navigationBar.orientation == .horizontal {
                    collectionView.setContentOffset(CGPoint(x: willSetOffSet, y: collectionView.contentOffset.y), animated: false)
                } else {
                    collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: willSetOffSet), animated: false)
                }
            }
            if progress > 0 {
                previousCell?.titleLabel.maskProgress = 0.0
                if self.layoutDirection == .rightToLeft && bmoViewPgaerNavigationBar?.orientation == .horizontal {
                    nextCell?.titleLabel.maskProgress = -1 * (1 - abs(progress))
                    focusCell?.titleLabel.maskProgress = 1 - abs(progress)
                } else {
                    nextCell?.titleLabel.maskProgress = progress
                    focusCell?.titleLabel.maskProgress = -1 * progress
                }
            } else if progress < 0 {
                nextCell?.titleLabel.maskProgress = 0.0
                if self.layoutDirection == .rightToLeft && bmoViewPgaerNavigationBar?.orientation == .horizontal {
                    previousCell?.titleLabel.maskProgress = -1 * progress
                    focusCell?.titleLabel.maskProgress = progress
                } else {
                    previousCell?.titleLabel.maskProgress = -1 * (1 - abs(progress))
                    focusCell?.titleLabel.maskProgress = 1 - abs(progress)
                }
            } else {
                nextCell?.titleLabel.maskProgress = 0.0
                previousCell?.titleLabel.maskProgress = 0.0
                focusCell?.titleLabel.maskProgress = 1.0
            }
        }
        lastProgress = progress
    }
    
    // MAKR: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if percentageLayer.animation(forKey: "percentage") == nil {
            bmoDelegate?.bmoViewPageItemList(self, didSelectItemAt: indexPath.row)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmoViewPagerCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BmoPageItemCell, let viewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return UICollectionViewCell()
        }
        let title = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemTitle?(viewPager, navigationBar: navigationBar, forPageListAt: indexPath.row) ?? ""
        var fraction: CGFloat = 0.0
        if indexPath.row == viewPager.presentedPageIndex {
            fraction = 1.0
        }
        if indexPath.row == viewPager.presentedPageIndex - 1 {
            if previousCell == nil {
                previousCell = cell
            }
        }
        if indexPath.row == viewPager.presentedPageIndex + 1 {
            if nextCell == nil {
                nextCell = cell
            }
        }
        let rearAttributed = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed?(viewPager, navigationBar: navigationBar, forPageListAt: indexPath.row)
        let backgroundView = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemNormalBackgroundView?(viewPager, navigationBar: navigationBar, forPageListAt: indexPath.row)
        let foreAttributed = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed?(viewPager, navigationBar: navigationBar, forPageListAt: indexPath.row)
        let foreBackgroundView = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView?(viewPager, navigationBar: navigationBar, forPageListAt: indexPath.row)
        cell.configureCell(title: title, focusProgress: fraction,
                           orientation: navigationBar.orientation,
                           rearAttributed: rearAttributed, foreAttributed: foreAttributed,
                           backgroundView: backgroundView, foreBackgroundView: foreBackgroundView)
        return cell
    }
    
    // MARK: - BmoPageItemListLayoutDelegate
    func bmoPageItemListLayoutAttributesChanged(_ attributes: [UICollectionViewLayoutAttributes], animated: Bool) {
        guard let collectionView = collectionView, let viewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return
        }
        var positionIndex = viewPager.presentedPageIndex
        if self.layoutDirection == .rightToLeft && bmoViewPgaerNavigationBar?.orientation == .horizontal {
            positionIndex = (bmoViewPagerCount - 1) - positionIndex
        }
        guard let attribute = collectionLayout.attributesList[safe: positionIndex] else {
            return
        }
        switch navigationBar.orientation {
        case .horizontal:
            if collectionView.contentSize.width < collectionView.bounds.width {
                return
            }
            var targetX: CGFloat = 0.0
            let distance = attribute.center.x - collectionView.center.x
            switch distance {
            case ...0:
                targetX = 0
            case 0..<collectionView.contentSize.width - collectionView.bounds.width:
                targetX = distance
            case (collectionView.contentSize.width - collectionView.bounds.width)...:
                targetX = collectionView.contentSize.width - collectionView.bounds.width
            default:
                break
            }
            self.focusIndex = -1
            collectionOffSet = targetX
            collectionView.setContentOffset(CGPoint(x: targetX, y: collectionView.contentOffset.y), animated: animated)
        case .vertical:
            if collectionView.contentSize.height < collectionView.bounds.height {
                return
            }
            var targetY: CGFloat = 0.0
            let distance = attribute.center.y - collectionView.center.y
            switch distance {
            case ...0:
                targetY = 0
            case 0..<collectionView.contentSize.height - collectionView.bounds.height:
                targetY = distance
            case (collectionView.contentSize.height - collectionView.bounds.height)...:
                targetY = collectionView.contentSize.height - collectionView.bounds.height
            default:
                break
            }
            self.focusIndex = -1
            collectionOffSet = targetY
            collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: targetY), animated: animated)
        }
    }
    func bmoPageItemListLayout(sizeForItemAt index: Int) -> CGSize {
        guard let collectionView = collectionView, let bmoViewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return CGSize.zero
        }
        if let size = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemSize?(bmoViewPager, navigationBar: navigationBar, forPageListAt: index), size != .zero {
            return size
        }
        guard let title = bmoDataSource?.bmoViewPagerDataSourceNaviagtionBarItemTitle?(bmoViewPager, navigationBar: navigationBar, forPageListAt: index) else {
            return CGSize.zero
        }
        calculateSizeLabel.text = title
        calculateSizeLabel.sizeToFit()
        let size = calculateSizeLabel.bounds.size
        if navigationBar.orientation == .horizontal {
            let width = UIScreen.main.bounds.width / 2
            return CGSize(width: width, height: collectionView.bounds.size.height)
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: size.height + 32)
        }
    }
}

class BmoPageItemCell: UICollectionViewCell {
    let titleLabel = BmoDoubleLabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit() {
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        titleLabel.bmoVP.autoFit(self.contentView)
    }
    func configureCell(title: String, focusProgress: CGFloat, orientation: UIPageViewControllerNavigationOrientation,
                       rearAttributed: [NSAttributedStringKey : Any]?, foreAttributed: [NSAttributedStringKey : Any]?,
                       backgroundView: UIView?, foreBackgroundView: UIView?) {
        titleLabel.text = title
        titleLabel.orientation = orientation
        if let view = backgroundView {
            titleLabel.setRearBackgroundView(view)
        }
        if let view = foreBackgroundView {
            titleLabel.setForeBackgroundView(view)
        }
        
        if let attributed = rearAttributed {
            let mutableAttributedText = NSMutableAttributedString(attributedString: titleLabel.rearLabel.attributedText ?? NSAttributedString())
            mutableAttributedText.addAttributes(attributed, range: NSRange(location: 0, length: title.count))
            titleLabel.rearAttributedText = mutableAttributedText
        } else {
            titleLabel.textColor = UIColor.lightGray
        }
        if let attributed = foreAttributed {
            let mutableAttributedText = NSMutableAttributedString(attributedString: titleLabel.foreLabel.attributedText ?? NSAttributedString())
            mutableAttributedText.addAttributes(attributed, range: NSRange(location: 0, length: title.count))
            titleLabel.foreAttributedText = mutableAttributedText
        } else {
            titleLabel.foreColor = UIColor.black
        }
        titleLabel.maskProgress = focusProgress
    }
}

class PercentageLayer: CALayer {
    var displayDo: ((_ percentage: CGFloat) -> Void)?
    @NSManaged var percentage: CGFloat
    
    override init() {
        super.init()
    }
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? PercentageLayer {
            percentage = layer.percentage
        } else {
            percentage = 0.0
        }
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        var needsDisplay = super.needsDisplay(forKey: key)
        if key == "percentage" {
            needsDisplay = true
        }
        return needsDisplay
    }
    
    override func action(forKey key: String) -> CAAction? {
        if displayDo == nil {
            return super.action(forKey: key)
        }
        guard let presentationLayer = presentation() else {
            return super.action(forKey: key)
        }
        if key == "percentage" {
            let animation = CABasicAnimation(keyPath: key)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = presentationLayer.percentage
            animation.duration = 0.33
            return animation
        }
        
        return super.action(forKey: key)
    }
    
    override func display() {
        guard let presentationLayer = presentation() else { return }
        displayDo?(presentationLayer.percentage)
    }
}
