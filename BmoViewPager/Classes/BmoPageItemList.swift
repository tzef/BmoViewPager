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
    let horizontalLayout = BmoPageItemListLayout()
    
    weak var bmoDelegate: BmoPageItemListDelegate!
    weak var bmoDataSource: BmoViewPagerDataSource?
    weak var bmoViewPager: BmoViewPager!
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
    convenience init(viewPager: BmoViewPager, delegate: BmoPageItemListDelegate) {
        self.init()
        self.bmoDelegate = delegate
        self.bmoViewPager = viewPager
        self.backgroundColor = .white
    }
    deinit {
        print("BmoPageItemList deinit")
    }
    func setCollectionView() {
        bmoViewPagerCount = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 0
        horizontalLayout.delegate = self
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: horizontalLayout)
        collectionView!.register(BmoPageItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.backgroundColor = .clear
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        self.addSubview(collectionView!)
        collectionView!.bmoVP.autoFit(self)
    }
    
    // MARK: - Public
    func reloadData() {
        if collectionView == nil {
            self.setCollectionView()
        }
        bmoViewPagerCount = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 0
        collectionView?.reloadData()
    }
    func updateFocusProgress(_ progress: inout CGFloat) {
        guard let collectionView = collectionView else {
            return
        }
        if horizontalLayout.attributesList.count == 0 {
            return
        }
        let index = bmoViewPager.presentedPageIndex
        if focusIndex != index {
            focusIndex = index
            collectionOffSet = collectionView.contentOffset.x
            focusCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? BmoPageItemCell
            if index < bmoViewPagerCount - 1 {
                nextIndex = index + 1
                nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)) as? BmoPageItemCell
            } else {
                if bmoViewPager.infinitScroll {
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
                if bmoViewPager.infinitScroll {
                    previousIndex = bmoViewPagerCount - 1
                    previousCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as? BmoPageItemCell
                } else {
                    previousCell = nil
                }
            }
            
            if let nextAttribute = horizontalLayout.attributesList[safe: nextIndex] {
                nextDistance = nextAttribute.center.x - collectionView.center.x - collectionOffSet
            }
            if let previousAttribute = horizontalLayout.attributesList[safe: previousIndex] {
                previousDistance = collectionView.center.x + collectionOffSet - previousAttribute.center.x
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BmoPageItemCell else {
            return UICollectionViewCell()
        }
        guard let title = bmoDataSource?.bmoViewPagerDataSourceTitle?(bmoViewPager, forPageListAt: indexPath.row) else {
            return cell
        }
        var fraction: CGFloat = 0.0
        if indexPath.row == bmoViewPager.presentedPageIndex {
            fraction = 1.0
        }
        let rearAttributed = bmoDataSource?.bmoViewPagerDataSourceAttributedTitle?(bmoViewPager, forPageListAt: indexPath.row)
        let backgroundView = bmoDataSource?.bmoViewPagerDataSourceListItemBackgroundView?(bmoViewPager, forPageListAt: indexPath.row)
        let foreAttributed = bmoDataSource?.bmoViewPagerDataSourceHighlightedAttributedTitle?(bmoViewPager, forPageListAt: indexPath.row)
        let foreBackgroundView = bmoDataSource?.bmoViewPagerDataSourceListItemHighlightedBackgroundView?(bmoViewPager,
                                                                                                         forPageListAt: indexPath.row)
        cell.configureCell(title: title, focusProgress: fraction,
                           rearAttributed: rearAttributed, foreAttributed: foreAttributed,
                           backgroundView: backgroundView, foreBackgroundView: foreBackgroundView)
        
        return cell
    }
    
    // MARK: - BmoPageItemListLayoutDelegate
    func bmoPageItemListLayout(sizeForItemAt index: Int) -> CGSize {
        if let size = bmoDataSource?.bmoViewPagerDataSourceListItemSize?(bmoViewPager, forPageListAt: index), size != .zero {
            return size
        }
        guard let title = bmoDataSource?.bmoViewPagerDataSourceTitle?(bmoViewPager, forPageListAt: index) else {
            return CGSize.zero
        }
        calculateSizeLabel.text = title
        calculateSizeLabel.sizeToFit()
        let size = calculateSizeLabel.bounds.size
        return CGSize(width: size.width + 32, height: size.height)
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
    func configureCell(title: String, focusProgress: CGFloat,
                       rearAttributed: [String : Any]?, foreAttributed: [String : Any]?,
                       backgroundView: UIView?, foreBackgroundView: UIView?) {
        titleLabel.text = title
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
