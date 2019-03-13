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

    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemSpace(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGFloat
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]?
    @objc optional func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]?
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

public class BmoViewPager: UIView {
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            if isHorizontal {
                orientation = UIPageViewController.NavigationOrientation.horizontal
            } else {
                orientation = UIPageViewController.NavigationOrientation.vertical
            }
        }
    }
    
    lazy var delegateProxy: BmoViewPagerDelegateProxy = {
        return BmoViewPagerDelegateProxy(viewPager: self, forwardDelegate: scrollViewDelegate ?? self, delegate: self)
    }()

    /// delegate of UIScrollview in BmoViewPager's UIPageViewController
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        didSet {
            delegateProxy.forwardDelegate = scrollViewDelegate
        }
    }

    /// UIScrollview in BmoViewPager's UIPageViewController
    weak var scrollView: UIScrollView? {
        didSet {
            delegateObserver = scrollView?.observe(\.delegate, options: [.new], changeHandler: { [weak self] (scrollView, value) in
                if let newDelegate = (value.newValue as? UIScrollViewDelegate), !(newDelegate is BmoViewPagerDelegateProxy) {
                    if let delegate = self?.pageViewController.scrollViewDelegate as? BmoViewPagerDelegateProxy {
                        delegate.forwardDelegate = newDelegate
                        scrollView.delegate = delegate
                    } else {
                        self?.delegateProxy.forwardDelegate = newDelegate
                        scrollView.delegate = self?.delegateProxy
                    }
                }
            })
        }
    }

    /// vierPager scroll orientataion
    public var orientation: UIPageViewController.NavigationOrientation = .horizontal {
        didSet {
            if orientation != pageViewController.navigationOrientation {
                #if swift(>=4.2)
                pageViewController.willMove(toParent: nil)
                pageViewController.view.removeFromSuperview()
                pageViewController.removeFromParent()
                #else
                pageViewController.willMove(toParentViewController: nil)
                pageViewController.view.removeFromSuperview()
                pageViewController.removeFromParentViewController()
                #endif
                pageViewController = BmoPageViewController(viewPager: self, scrollDelegate: delegateProxy, orientation: self.orientation)
                
                if let vc = parentViewController {
                    #if swift(>=4.2)
                    vc.addChild(pageViewController)
                    self.addSubview(pageViewController.view)
                    pageViewController.view.bmoVP.autoFit(self)
                    pageViewController.didMove(toParent: vc)
                    #else
                    vc.addChildViewController(pageViewController)
                    self.addSubview(pageViewController.view)
                    pageViewController.view.bmoVP.autoFit(self)
                    pageViewController.didMove(toParentViewController: vc)
                    #endif
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
                #if swift(>=4.2)
                vc.addChild(pageViewController)
                vc.automaticallyAdjustsScrollViewInsets = false
                pageViewController.didMove(toParent: vc)
                #else
                vc.addChildViewController(pageViewController)
                vc.automaticallyAdjustsScrollViewInsets = false
                pageViewController.didMove(toParentViewController: vc)
                #endif
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
    
    /// enable page changed animation, it work or not depend on viewPgaer have the page viewController's referecne
    public var isInterporationAnimated: Bool = true

    public var scrollable: Bool = true {
        didSet {
            if !inited { return }
            pageViewController.scrollable = scrollable
        }
    }

    /// between 0.0 to 1.0, default is 0.0
    public var edgeMaskPercentage: Float = 0.0
    /// how much offset let mask enlarge to max, default is 32.0
    public var edgeMaskTriggerOffset: Float = 32.0

    public var lastPresentedPageIndex: Int = 0
    private var _presentedPageIndex: Int = 0
    public var presentedPageIndex: Int {
        get {
            return _presentedPageIndex
        }
        set {
            guard inited else {
                _presentedPageIndex = newValue
                return
            }
            if _presentedPageIndex != newValue {
                if !presentedIndexInternalFlag && isInterporationAnimated {
                    if let bar = self.navigationBars.first?.bar {
                        bar.bmoViewPageItemList(didSelectItemAt: newValue, previousIndex: _presentedPageIndex)
                    } else {
                        self.addSubview(defaultNavigaionBar)
                        defaultNavigaionBar.viewPager = self
                        defaultNavigaionBar.bmoViewPageItemList(didSelectItemAt: newValue, previousIndex: _presentedPageIndex)
                    }
                    return
                }
                lastPresentedPageIndex = _presentedPageIndex
                if newValue != self.pageControlIndex {
                    pageViewController.setViewPagerPageCompletion = { [weak self] (page) in
                        self?.navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
                            if let bar = weakBar.bar {
                                bar.reloadData()
                            }
                        }
                    }
                }
                _presentedPageIndex = newValue
                self.pageControlIndex = presentedPageIndex
                if let view = pageViewController.pageScrollView?.subviews[safe: 1] {
                    if let vc = view.subviews.first?.bmoVP.ownerVC(), view.subviews.first?.bmoVP.index() == presentedPageIndex {
                        self.delegate?.bmoViewPagerDelegate?(self, didAppear: vc, page: presentedPageIndex)
                        return
                    }
                }
                pageViewController.setViewControllerIng = false
                pageViewController.setViewPagerPage(presentedPageIndex)
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
    
    lazy var pageViewController: BmoPageViewController = {
        let pageVC = BmoPageViewController(viewPager: self, scrollDelegate: delegateProxy, orientation: self.orientation)
        
        self.addSubview(pageVC.view)
        pageVC.view.bmoVP.autoFit(self)
        return pageVC
    }()

    internal var referencePageViewControllers = [Int : WeakBmoVPpageViewController]()
    internal var navigationBars = [WeakBmoVPbar]()
    
    private let defaultNavigaionBar = BmoViewPagerNavigationBar()
    private var presentedIndexInternalFlag = false
    private var delegateObserver: NSKeyValueObservation?
    private var lastContentOffSet: CGPoint? = nil
    private var boundChanged: Bool = false
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
    
    public override var bounds: CGRect {
        didSet {
            boundChanged = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.boundChanged = false
            }
        }
    }
    deinit {
        delegateObserver?.invalidate()
        delegateObserver = nil
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(initPage: Int, orientation: UIPageViewController.NavigationOrientation = .horizontal) {
        self.init()
        self.internalSetPresentedIndex(initPage)
        self.isHorizontal = (orientation == .horizontal)
        delegateObserver = scrollView?.observe(\.delegate, options: [.new], changeHandler: { [weak self] (scrollView, value) in
            if let newDelegate = (value.newValue as? UIScrollViewDelegate), !(newDelegate is BmoViewPagerDelegateProxy) {
                if let delegate = self?.pageViewController.scrollViewDelegate as? BmoViewPagerDelegateProxy  {
                    delegate.forwardDelegate = newDelegate
                } else {
                    self?.delegateProxy.forwardDelegate = newDelegate
                    scrollView.delegate = self?.delegateProxy
                }
            }
        })
    }
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if inited == false {            
            pageControlIndex = presentedPageIndex
            inited = true
            if let vc = self.parentViewController {
                #if swift(>=4.2)
                vc.addChild(pageViewController)
                pageViewController.didMove(toParent: vc)
                #else
                vc.addChildViewController(pageViewController)
                pageViewController.didMove(toParentViewController: vc)
                #endif
            }
            pageViewController.infinitScroll = self.infinitScroll
            pageViewController.scrollable = self.scrollable
            pageViewController.reloadData()
            
            if self.orientation == .horizontal {
                self.pageViewController.view.layer.mask = maskLayerHorizontal
            } else {
                self.pageViewController.view.layer.mask = maskLayerVertical
            }
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
    public func setReferencePageViewController(_ vc: UIViewController, at page: Int) {
        if getReferencePageViewController(at: page) == vc {
            return
        }
        for (key, element) in referencePageViewControllers {
            if element.vc == nil {
                referencePageViewControllers[key] = nil
            }
        }
        vc.view.bmoVP.setOwner(vc)
        vc.view.bmoVP.setIndex(page)
        referencePageViewControllers[page] = WeakBmoVPpageViewController(vc)
    }
    public func getReferencePageViewController(at page: Int) -> UIViewController? {
        return referencePageViewControllers[page]?.vc
    }
    public func reloadData(autoAnimated: Bool = true) {
        if !inited { return }
        DispatchQueue.main.async {
            self.inited = false
            self.referencePageViewControllers.removeAll()
            if self.dataSource?.bmoViewPagerDataSourceNumberOfPage(in: self) ?? 0 <= self.presentedPageIndex {
                self.internalSetPresentedIndex(0)
            }
            self.navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
                if let bar = weakBar.bar {
                    bar.reloadData(autoAnimated: autoAnimated)
                }
            }
            self.pageViewController.reloadData()
            self.inited = true
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.maskLayerVertical.frame = self.bounds
        self.maskLayerHorizontal.frame = self.bounds
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
            NSAttributedString.Key.foregroundColor  : UIColor.black,
            NSAttributedString.Key.font             : UIFont.boldSystemFont(ofSize: 24.0),
        ]
        let subAttributed = [
            NSAttributedString.Key.foregroundColor  : UIColor.lightGray,
            NSAttributedString.Key.font             : UIFont.boldSystemFont(ofSize: 17.0),
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
    
    internal func internalSetPresentedIndex(_ index: Int) {
        presentedIndexInternalFlag = true
        self.presentedPageIndex = index
        presentedIndexInternalFlag = false
    }
}

extension BmoViewPager: BmoViewPagerDelegateProxyDataSource {
    func isBoundChanged() -> Bool {
        return self.boundChanged
    }
    func getLastContentOffSet() -> CGPoint? {
        return self.lastContentOffSet
    }
    func setLastContentOffSet(_ point: CGPoint) {
        self.lastContentOffSet = point
    }
    func setLastScrollAbsProgress(_ fraction: CGFloat) {
        if let bounds = scrollView?.bounds, self.edgeMaskPercentage > 0.0 {
            let length = (self.orientation == .horizontal ? bounds.width : bounds.height)
            var offsetValue: Float = 0.0
            if fraction > 0.5 {
                offsetValue = Float(length * (1 - fraction))
            } else {
                offsetValue = Float(length * fraction)
            }
            let percentage = (1 - max((self.edgeMaskTriggerOffset - offsetValue), 0) / self.edgeMaskTriggerOffset) * self.edgeMaskPercentage
            let fraction1 = NSNumber(value: percentage * 0.5)
            let fraction2 = NSNumber(value: 1 - percentage * 0.5)
            self.maskLayerVertical.locations = [0.0, fraction1, fraction2, 1.0]
            self.maskLayerHorizontal.locations = [0.0, fraction1, fraction2, 1.0]
        }
    }
}

