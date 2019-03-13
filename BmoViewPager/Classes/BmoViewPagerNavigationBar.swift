//
//  BmoViewPagerNavigationBar.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/6/17.
//
//

import UIKit

class WeakBmoVPbar<T: BmoViewPagerNavigationBar> {
    weak var bar : T?
    init (_ bar: T) {
        self.bar = bar
    }
}

@IBDesignable
public class BmoViewPagerNavigationBar: UIView {
    deinit {
        contentOffsetObserver?.invalidate()
        contentOffsetObserver = nil
    }

    public weak var viewPager: BmoViewPager? {
        didSet {
            if let viewPager = viewPager, inited == true {
                self.resetViewPager(viewPager)
            }
        }
    }
    
    /// enable auto focus, will find the nearest center position for next item
    public var autoFocus: Bool = true {
        didSet {
            pageListView?.autoFocus = autoFocus
        }
    }

    /// between 0.0 to 1.0, default is 0.0
    public var edgeMaskPercentage: Float = 0.0
    /// how much offset let mask enlarge to max, default is 16.0
    public var edgeMaskTriggerOffset: Float = 16.0

    /// vierPager's navigation bar scroll orientataion
    public var orientation: UIPageViewController.NavigationOrientation = .horizontal
    
    /// if you not allow user change viewPager page by tap navigation bar item, disable it
    public var isEnabledTapEvent: Bool = true
    
    /// enable navigation bar animation when change viewPager page by tap navigationItem
    public var isInterpolationAnimated: Bool = true
    
    weak var pageViewController: BmoPageViewController?
    private weak var pageListView: BmoPageItemList?
    private var itemListSelectBlock = false
    private var contentOffsetObserver: NSKeyValueObservation?
    private lazy var maskLayerHorizontal: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.locations = [0.0, 0.0, 1.0, 1.0]
        return layer
    }()
    private lazy var maskLayerVertical: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.locations = [0.0, 0.0, 1.0, 1.0]
        return layer
    }()
    private var inited = false
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if inited == false {
            inited = true
            if let viewPager = viewPager {
                self.resetViewPager(viewPager)
            }
        }
        if self.orientation == .horizontal {
            self.pageListView?.layer.mask = maskLayerHorizontal
        } else {
            self.pageListView?.layer.mask = maskLayerVertical
        }
        self.contentOffsetObserver = pageListView?.collectionView?.observe(\.contentOffset, options: [.new], changeHandler: { [unowned self] (collectionView, value) in
            if let offset = value.newValue, self.edgeMaskPercentage > 0.0 {
                let offsetValue: Float = self.orientation == .horizontal ? Float(offset.x) : Float(offset.y)
                let percentage = (1 - max((self.edgeMaskTriggerOffset - offsetValue), 0) / self.edgeMaskTriggerOffset) * self.edgeMaskPercentage
                let fraction1 = NSNumber(value: percentage * 0.5)
                var fraction2 = NSNumber(value: 1 - percentage * 0.5)
                if self.orientation == .horizontal {
                    if offset.x + collectionView.bounds.width >= collectionView.contentSize.width {
                        fraction2 = 1.0
                    } else if percentage < 1.0 {
                        fraction2 = NSNumber(value: 1 - self.edgeMaskPercentage * 0.5)
                    }
                } else {
                    if offset.y + collectionView.bounds.height >= collectionView.contentSize.height {
                        fraction2 = 1.0
                    } else if percentage < 1.0 {
                        fraction2 = NSNumber(value: 1 - self.edgeMaskPercentage * 0.5)
                    }
                }
                self.maskLayerVertical.locations = [0.0, fraction1, fraction2, 1.0]
                self.maskLayerHorizontal.locations = [0.0, fraction1, fraction2, 1.0]
            }
        })
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        maskLayerVertical.frame = self.bounds
        maskLayerHorizontal.frame = self.bounds
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.viewPager != nil { return }
        let str1 = "BMO ViewPager NavigationBar"
        let str2 = "Need to assign a BmoViewPager"
        let mainAttributed = [
            NSAttributedString.Key.foregroundColor  : UIColor.black,
            NSAttributedString.Key.font             : UIFont.boldSystemFont(ofSize: 24.0),
            ]
        let subAttributed = [
            NSAttributedString.Key.foregroundColor  : UIColor.lightGray,
            NSAttributedString.Key.font             : UIFont.boldSystemFont(ofSize: 17.0),
            ]
        let str1Size = str1.bmoVP.size(attribute: mainAttributed, size: .zero)
        let str2Size = str2.bmoVP.size(attribute: subAttributed, size: .zero)
        let totalHeight = str1Size.height + str2Size.height + 8
        let str1Point = CGPoint(x: rect.midX - str1Size.width / 2, y: rect.midY - totalHeight / 2)
        let str2Point = CGPoint(x: rect.midX - str2Size.width / 2, y: str1Point.y + str1Size.height)
        (str1 as NSString).draw(at: str1Point, withAttributes: mainAttributed)
        (str2 as NSString).draw(at: str2Point, withAttributes: subAttributed)
    }
    
    public override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    /// if the viewpager position changed by navigation bar, cause the navigatoin position become weird, need to reset contentInset to solve cell wrong position issue
    public func resetContentInset() {
        self.pageListView?.collectionView?.contentInset = .zero
    }
    
    public func reloadData(autoAnimated: Bool = true) {
        guard let viewPager = viewPager else {
            return
        }
        if isInterpolationAnimated && autoAnimated {
            self.pageListView?.focusFrom(index: viewPager.lastPresentedPageIndex)
        } else {
            self.pageListView?.reloadData()
        }
    }
    
    public func focusToTargetItem() {
        self.pageListView?.focusToTargetItem()
    }

    func updateFocusProgress(_ progress: inout CGFloat) {
        guard let viewPager = viewPager else {
            return
        }
        self.pageListView?.updateFocusProgress(&progress, index: viewPager.presentedPageIndex)
    }
    
    private func resetViewPager(_ viewPager: BmoViewPager) {
        var existBarIndex = -1
        viewPager.navigationBars.enumerated().forEach { (offset: Int, element: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
            if element.bar == self {
                existBarIndex = offset
                element.bar?.removeFromSuperview()
            }
        }
        if existBarIndex > 0 {
            viewPager.navigationBars.remove(at: existBarIndex)
        }
        self.pageViewController = viewPager.pageViewController
        viewPager.navigationBars.append(WeakBmoVPbar(self))
        
        let itemList = BmoPageItemList(viewPager: viewPager, navigationBar: self, delegate: self)
        itemList.bmoDataSource = viewPager.dataSource
        itemList.backgroundColor = UIColor.clear
        itemList.autoFocus = autoFocus
        itemList.reloadData()
        
        self.subviews.forEach { (view) in
            if view is BmoPageItemList {
                view.removeFromSuperview()
            }
        }
        self.addSubview(itemList)
        itemList.bmoVP.autoFit(self)
        
        pageListView = itemList
    }
}

extension BmoViewPagerNavigationBar: BmoPageItemListDelegate {
    func bmoViewPageItemList(didSelectItemAt index: Int, previousIndex: Int?) {
        if isEnabledTapEvent == false || itemListSelectBlock {
            return
        }
        guard let viewPager = viewPager else {
            return
        }
        if viewPager.delegate?.bmoViewPagerDelegate?(viewPager, shouldSelect: index) == false {
            return
        }
        itemListSelectBlock = true
        pageViewController?.pageScrollView?.isScrollEnabled = false
        var scrollPosition = -1
        if index == (previousIndex ?? viewPager.presentedPageIndex) + 1 {
            scrollPosition = 2
        } else if index == (previousIndex ?? viewPager.presentedPageIndex) - 1 {
            scrollPosition = 0
        } else if index == 0 && viewPager.infinitScroll == true {
            if let pageCount = pageListView?.bmoViewPagerCount, previousIndex == pageCount - 1 {
                scrollPosition = 2
            }
        }
        let changePage = { [weak self] in
            self?.itemListSelectBlock = false
            self?.pageListView?.focusIndex = -1
            self?.viewPager?.internalSetPresentedIndex(index)
            self?.pageViewController?.pageScrollView?.isScrollEnabled = viewPager.scrollable
        }
        if viewPager.isInterporationAnimated {
            if let container = pageViewController?.pageScrollView?.subviews[safe: scrollPosition] {
                if let vc = viewPager.getReferencePageViewController(at: index) {
                    container.addSubview(vc.view)
                    vc.view.frame = container.bounds
                    pageViewController?.pageScrollView?.setContentOffset(container.frame.origin, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                        changePage()
                    }
                    return
                }
            }
        }
        changePage()
    }
}
