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
    let horizontalLayout = BmoPageItemListLayout(orientation: .horizontal)
    let verticalLayout = BmoPageItemListLayout(orientation: .vertical)
    
    weak var bmoViewPager: BmoViewPager?
    weak var bmoDelegate: BmoPageItemListDelegate?
    weak var bmoDataSource: BmoViewPagerDataSource?
    weak var bmoViewPgaerNavigationBar: BmoViewPagerNavigationBar?
    var bmoViewPagerCount = 0
    var focusCell, nextCell, previousCell: BmoPageItemCell?
    
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
    }
    func setCollectionView() {
        guard let bmoViewPager = bmoViewPager else {
            return
        }
        verticalLayout.delegate = self
        horizontalLayout.delegate = self
        bmoViewPagerCount = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 0
        if bmoViewPgaerNavigationBar?.orientation == .vertical {
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: verticalLayout)
        } else {
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: horizontalLayout)
        }
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
            return
        }
        if collectionView == nil {
            self.setCollectionView()
        }
        bmoViewPagerCount = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 0
        collectionView?.reloadData()
    }
    func updateFocusProgress(_ progress: inout CGFloat) {
        guard let collectionView = collectionView, let viewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return
        }
        let layout = (navigationBar.orientation == .horizontal ? horizontalLayout : verticalLayout)
        if layout.attributesList.count == 0 {
            return
        }
        let index = viewPager.presentedPageIndex
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
            
            if let nextAttribute = layout.attributesList[safe: nextIndex] {
                if navigationBar.orientation == .horizontal {
                    nextDistance = nextAttribute.center.x - collectionView.center.x - collectionOffSet
                } else {
                    nextDistance = nextAttribute.center.y - collectionView.center.y - collectionOffSet
                }
            }
            if let previousAttribute = layout.attributesList[safe: previousIndex] {
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
            if progress >= 1.0 || progress <= -1.0 {
                progress = lastProgress
            }
            if progress > 0 {
                if autoFocus {
                    var willSetOffSet = collectionOffSet + nextDistance * progress
                    if willSetOffSet > collectionView.contentSize.width - collectionView.bounds.width {
                        willSetOffSet = collectionView.contentSize.width - collectionView.bounds.width
                    }
                    if willSetOffSet < 0 {
                        willSetOffSet = 0
                    }
                    collectionView.setContentOffset(CGPoint(x: willSetOffSet, y: collectionView.contentOffset.y), animated: false)
                }
                previousCell?.titleLabel.maskProgress = 0.0
                nextCell?.titleLabel.maskProgress = progress
                focusCell?.titleLabel.maskProgress = -1 * progress
            } else if progress < 0 {
                if autoFocus {
                    var willSetOffSet = collectionOffSet + previousDistance * progress
                    if willSetOffSet > collectionView.contentSize.width - collectionView.bounds.width {
                        willSetOffSet = collectionView.contentSize.width - collectionView.bounds.width
                    }
                    if willSetOffSet < 0 {
                        willSetOffSet = 0
                    }
                    collectionView.setContentOffset(CGPoint(x: willSetOffSet, y: collectionView.contentOffset.y), animated: false)
                }
                nextCell?.titleLabel.maskProgress = 0.0
                focusCell?.titleLabel.maskProgress = 1 - abs(progress)
                previousCell?.titleLabel.maskProgress = -1 * (1 - abs(progress))
            } else {
                nextCell?.titleLabel.maskProgress = 0.0
                focusCell?.titleLabel.maskProgress = 1.0
                previousCell?.titleLabel.maskProgress = 0.0
            }
        }
        lastProgress = progress
    }
    
    // MAKR: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bmoDelegate?.bmoViewPageItemList(self, didSelectItemAt: indexPath.row)
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
        
        if indexPath.row == viewPager.presentedPageIndex - 1 {
            if previousCell == nil {
                previousCell = cell
            }
        }
        if indexPath.row == viewPager.presentedPageIndex {
            fraction = 1.0
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
    func bmoPageItemListLayoutAttributesChanged(_ attributes: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView, let viewPager = bmoViewPager, let navigationBar = bmoViewPgaerNavigationBar else {
            return
        }
        let index = viewPager.presentedPageIndex
        let layout = (navigationBar.orientation == .horizontal ? horizontalLayout : verticalLayout)
        if let attribute = layout.attributesList[safe: index] {
            if navigationBar.orientation == .horizontal {
                let distance = attribute.center.x - collectionView.center.x - collectionView.contentOffset.x
                collectionView.setContentOffset(CGPoint(x: distance, y: collectionView.contentOffset.y), animated: false)
            } else {
                let distance = attribute.center.y - collectionView.center.y - collectionView.contentOffset.y
                collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: distance), animated: false)
            }
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
            return CGSize(width: size.width + 32, height: collectionView.bounds.size.height)
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
                       rearAttributed: [String : Any]?, foreAttributed: [String : Any]?,
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
            mutableAttributedText.addAttributes(attributed, range: NSRange(location: 0, length: title.characters.count))
            titleLabel.attributedText = mutableAttributedText
        } else {
            titleLabel.textColor = UIColor.lightGray
        }
        if let attributed = foreAttributed {
            let mutableAttributedText = NSMutableAttributedString(attributedString: titleLabel.foreLabel.attributedText ?? NSAttributedString())
            mutableAttributedText.addAttributes(attributed, range: NSRange(location: 0, length: title.characters.count))
            titleLabel.foreAttributedText = mutableAttributedText
        } else {
            titleLabel.foreColor = UIColor.black
        }
        titleLabel.maskProgress = focusProgress
    }
}
