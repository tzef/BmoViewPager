//
//  BmoViewPager.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

@objc public protocol BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController
    
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemNormalBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView?
}
@objc public protocol BmoViewPagerDelegate {
    @objc optional func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int)
    @objc optional func bmoViewPagerDelegate(_ viewPager: BmoViewPager, shouldSelect page: Int) -> Bool
    @objc optional func bmoViewPagerDelegate(_ viewPager: BmoViewPager, scrollProgress fraction: CGFloat, index: Int)
    @objc optional func bmoViewPagerDelegate(_ viewPager: BmoViewPager, didAppear viewController: UIViewController, page: Int)
}

@IBDesignable
public class BmoViewPager: UIView, UIScrollViewDelegate {
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            if isHorizontal {
                orientation = UIPageViewControllerNavigationOrientation.horizontal
            } else {
                orientation = UIPageViewControllerNavigationOrientation.vertical
            }
        }
    }
    
    /// vierPager scroll orientataion
    public var orientation: UIPageViewControllerNavigationOrientation = .horizontal {
        didSet {
            if orientation != pageViewController.navigationOrientation {
                pageViewController.didMove(toParentViewController: nil)
                pageViewController.view.removeFromSuperview()
                pageViewController.removeFromParentViewController()
                pageViewController = BmoPageViewController(viewPager: self, scrollDelegate: self, orientation: self.orientation)
                
                if let vc = parentViewController {
                    vc.addChildViewController(pageViewController)
                    self.addSubview(pageViewController.view)
                    pageViewController.view.bmoVP.autoFit(self)
                    pageViewController.didMove(toParentViewController: vc)
                }
                pageViewController.infinitScroll = infinitScroll
                pageViewController.bmoDataSource = dataSource
                pageViewController.scrollable = scrollable
                pageViewController.reloadData()
            }
        }
    }
    
    /**
     if you need get parent view controller from viewPager's view controller, pass into the bmoViewPager's owner
     if the parent view controller as same as the datasource, it will autoset to bmoViewPager's parent view controller
     */
    public weak var parentViewController: UIViewController? {
        didSet {
            if let vc = parentViewController {
                vc.addChildViewController(pageViewController)
                vc.automaticallyAdjustsScrollViewInsets = false
                pageViewController.didMove(toParentViewController: vc)
            }
        }
    }
    
    /// enable infinit scroll setting, the page which next the last page will return the first page. 
    public var infinitScroll: Bool = false {
        didSet {
            if !inited { return }
            pageViewController.infinitScroll = infinitScroll
        }
    }
    
    public var scrollable: Bool = true {
        didSet {
            if !inited { return }
            pageViewController.scrollable = scrollable
        }
    }

    public var lastPresentedPageIndex: Int = 0
    public var presentedPageIndex: Int = 0 {
        didSet {
            if !inited { return }
            if oldValue != presentedPageIndex {
                lastPresentedPageIndex = oldValue
                if self.presentedPageIndex != self.pageControlIndex {
                    navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
                        if let bar = weakBar.bar {
                            bar.reloadData()
                            if bar.autoFocus {
                                bar.focusToTargetItem()
                            }
                        }
                    }
                }
                self.pageControlIndex = presentedPageIndex
                var reuseIt = false
                if let view = pageViewController.pageScrollView?.subviews[safe: 1] {
                    if let vc = view.subviews.first?.bmoVP.ownerVC(), view.subviews.first?.bmoVP.index() == presentedPageIndex {
                        self.delegate?.bmoViewPagerDelegate?(self, didAppear: vc, page: presentedPageIndex)
                        reuseIt = true
                    }
                }
                if reuseIt == false {
                    pageViewController.setViewPagerPage(presentedPageIndex)
                }
            }
        }
    }
    
    public var pageControlIndex: Int = 0 {
        didSet {
            if !inited { return }
            if oldValue != pageControlIndex {
                self.delegate?.bmoViewPagerDelegate?(self, pageChanged: pageControlIndex)
            }
        }
    }
    
    public weak var dataSource: BmoViewPagerDataSource? {
        didSet {
            pageViewController.bmoDataSource = dataSource
            self.parentViewController = (dataSource as? UIViewController)
        }
    }
    public weak var delegate: BmoViewPagerDelegate?
    
    var navigationBars = [WeakBmoVPbar]()
    
    lazy var pageViewController: BmoPageViewController = {
        let pageVC = BmoPageViewController(viewPager: self, scrollDelegate: self, orientation: self.orientation)
        self.addSubview(pageVC.view)
        pageVC.view.bmoVP.autoFit(self)
        return pageVC
    }()
    
    fileprivate var lastContentOffSet: CGPoint? = nil
    fileprivate var boundChanged: Bool = false
    fileprivate var inited = false
    
    public override var bounds: CGRect {
        didSet {
            boundChanged = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.boundChanged = false
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(initPage: Int, orientation: UIPageViewControllerNavigationOrientation = .horizontal) {
        self.init()
        self.presentedPageIndex = initPage
        self.isHorizontal = (orientation == .horizontal)
    }
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if inited == false {            
            pageControlIndex = presentedPageIndex
            inited = true
            if let vc = self.parentViewController {
                vc.addChildViewController(pageViewController)
                pageViewController.didMove(toParentViewController: vc)
            }
            pageViewController.infinitScroll = self.infinitScroll
            pageViewController.scrollable = self.scrollable
            pageViewController.reloadData()
        }
    }
    /// if the viewpager position changed by navigation bar, cause the navigatoin position become weird, need to reset contentInset to solve cell wrong position issue
    public func navigationLayoutChanged() {
        navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
            if let bar = weakBar.bar {
                bar.resetContentInset()
            }
        }
    }
    
    // MARK: - Public
    public func reloadData() {
        inited = false
        if dataSource?.bmoViewPagerDataSourceNumberOfPage(in: self) ?? 0 <= presentedPageIndex {
            presentedPageIndex = 0
        }
        navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
            if let bar = weakBar.bar {
                bar.reloadData()
            }
        }
        pageViewController.reloadData()
        inited = true
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if boundChanged { return }
        let offSet = lastContentOffSet ?? scrollView.contentOffset
        if self.orientation == .horizontal {
            if abs(offSet.x - scrollView.contentOffset.x) > scrollView.bounds.width * 0.7 {
                self.presentedPageIndex = self.pageControlIndex
            }
            if scrollView.contentOffset.x == scrollView.bounds.width {
                if let index = scrollView.subviews[safe: 1]?.subviews.first?.bmoVP.index() {
                    pageControlIndex = index
                }
                return
            }
        } else {
            if abs(offSet.y - scrollView.contentOffset.y) > scrollView.bounds.height * 0.7 {
                self.presentedPageIndex = self.pageControlIndex
            }
            if scrollView.contentOffset.y == scrollView.bounds.height {
                if let index = scrollView.subviews[safe: 1]?.subviews.first?.bmoVP.index() {
                    pageControlIndex = index
                }
                return
            }
        }
        lastContentOffSet = scrollView.contentOffset
        var progressFraction: CGFloat = 0.0
        if self.orientation == .horizontal {
            let originX = scrollView.contentOffset.x
            progressFraction = (originX - scrollView.bounds.width) / scrollView.bounds.width
        } else {
            let originY = scrollView.contentOffset.y
            progressFraction = (originY - pageViewController.view.bounds.height) / pageViewController.view.bounds.height
        }
        var targetIndex = 0
        if progressFraction > 0.0 {
            targetIndex = (progressFraction > 0.5 ? 2 : 1)
        }
        if progressFraction < 0.0 {
            targetIndex = (progressFraction < -0.5 ? 0 : 1)
        }
        if let index = scrollView.subviews[safe: targetIndex]?.subviews.first?.bmoVP.index() {
            pageControlIndex = index
        }
        delegate?.bmoViewPagerDelegate?(self, scrollProgress: progressFraction, index: pageControlIndex)
        navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
            if let bar = weakBar.bar {
                bar.updateFocusProgress(&progressFraction)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.pageViewController.view.setNeedsLayout()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.dataSource != nil { return }
        let str1 = "BMO ViewPager"
        let str2 = "Need to implement"
        let str3 = "BmoViewPagerDataSource"
        let str4 = "And assign to the BmoViewPager"
        let mainAttributed = [
            NSAttributedStringKey.foregroundColor  : UIColor.black,
            NSAttributedStringKey.font             : UIFont.boldSystemFont(ofSize: 24.0),
        ]
        let subAttributed = [
            NSAttributedStringKey.foregroundColor  : UIColor.lightGray,
            NSAttributedStringKey.font             : UIFont.boldSystemFont(ofSize: 17.0),
            ]
        let str1Size = str1.bmoVP.size(attribute: mainAttributed, size: .zero)
        let str2Size = str2.bmoVP.size(attribute: subAttributed, size: .zero)
        let str3Size = str3.bmoVP.size(attribute: subAttributed, size: .zero)
        let str4Size = str4.bmoVP.size(attribute: subAttributed, size: .zero)
        let totalHeight = str1Size.height + str2Size.height + str3Size.height + str4Size.height + 8 * 3
        let str1Point = CGPoint(x: rect.midX - str1Size.width / 2, y: rect.midY - totalHeight / 2)
        let str2Point = CGPoint(x: rect.midX - str2Size.width / 2, y: str1Point.y + str1Size.height + 8)
        let str3Point = CGPoint(x: rect.midX - str3Size.width / 2, y: str2Point.y + str2Size.height + 8)
        let str4Point = CGPoint(x: rect.midX - str4Size.width / 2, y: str3Point.y + str3Size.height + 8)
        (str1 as NSString).draw(at: str1Point, withAttributes: mainAttributed)
        (str2 as NSString).draw(at: str2Point, withAttributes: subAttributed)
        (str3 as NSString).draw(at: str3Point, withAttributes: subAttributed)
        (str4 as NSString).draw(at: str4Point, withAttributes: subAttributed)
    }
}
