//
//  BmoPageViewController.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

class WeakBmoVPpageViewController<T: UIViewController> {
    weak var vc : T?
    init (_ vc: T) {
        self.vc = vc
    }
}

class BmoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    weak var scrollViewDelegate: UIScrollViewDelegate?
    weak var bmoDataSource: BmoViewPagerDataSource?
    weak var bmoViewPager: BmoViewPager!
    weak var pageScrollView: UIScrollView? {
        didSet {
            bmoViewPager.scrollView = pageScrollView
        }
    }
    var setViewControllerIng = false
    var infinitScroll: Bool = false
    var scrollable: Bool = true {
        didSet {
            pageScrollView?.isScrollEnabled = scrollable
        }
    }
    var pageCount = 0
    var setViewPagerPageCompletion: ((_ page: Int) -> Void)?
    
    init(_ orientation: UIPageViewController.NavigationOrientation) {
        super.init(transitionStyle: .scroll, navigationOrientation: orientation, options: nil)
    }
    convenience init(viewPager: BmoViewPager, scrollDelegate: UIScrollViewDelegate?,
                     orientation: UIPageViewController.NavigationOrientation = .horizontal) {
        self.init(orientation)
        self.bmoViewPager = viewPager
        self.view.backgroundColor = .clear
        self.scrollViewDelegate = scrollDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.findScrollViewIfNeed()
        self.pageScrollView?.frame = self.view.bounds
    }
    
    // MARK: - Private
    private func findScrollViewIfNeed() {
        if self.pageScrollView != nil {
            return
        }
        for subView in self.view.subviews {
            if let scrollView = subView as? UIScrollView {
                self.pageScrollView = scrollView
                scrollView.delegate = scrollViewDelegate
                scrollView.isScrollEnabled = scrollable
            }
        }
    }
    private func setPageViewController() {
        guard let count = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager), count > 0 else {
            self.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
            return
        }
        pageCount = count
        let cacheVC = bmoViewPager.getReferencePageViewController(at: bmoViewPager.presentedPageIndex)
        if let firstVC = cacheVC ?? bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: bmoViewPager.presentedPageIndex) {
            self.delegate = self
            self.dataSource = self
            firstVC.view.bmoVP.setOwner(firstVC)
            firstVC.view.bmoVP.setIndex(bmoViewPager.presentedPageIndex)
            bmoViewPager.setReferencePageViewController(firstVC, at: bmoViewPager.presentedPageIndex)
            setViewControllerIng = true
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: { [weak self] (finished) in
                self?.pageScrollView?.isScrollEnabled = self?.bmoViewPager.scrollable ?? true
                self?.setViewControllerIng = false
            })
            bmoViewPager.delegate?.bmoViewPagerDelegate?(bmoViewPager, pageChanged: bmoViewPager.pageControlIndex)
            bmoViewPager.delegate?.bmoViewPagerDelegate?(bmoViewPager, didAppear: firstVC, page: bmoViewPager.presentedPageIndex)
        }
        if pageCount == 1 {
            self.dataSource = nil
        }
    }
    
    // MARK: - Public
    public func reloadData() {
        self.setPageViewController()
    }
    public func setViewPagerPage(_ page: Int) {
        if setViewControllerIng { return }
        if page >= pageCount { return }
        let cacheVC = bmoViewPager.getReferencePageViewController(at: page)
        if let vc = cacheVC ?? bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: page) {
            setViewControllerIng = true
            self.setViewControllers([vc], direction: .forward, animated: false, completion: { [weak self] (finished) in
                if let viewPager = self?.bmoViewPager {
                    viewPager.delegate?.bmoViewPagerDelegate?(viewPager, didAppear: vc, page: page)
                    viewPager.setReferencePageViewController(vc, at: page)
                    vc.view.bmoVP.setIndex(page)
                    vc.view.bmoVP.setOwner(vc)
                }
                self?.setViewPagerPageCompletion?(page)
                self?.setViewPagerPageCompletion = nil
                self?.setViewControllerIng = false
            })
        }
    }
    
    // MARK: - PageViewDelegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var nextIndex = (viewController.view.bmoVP.index() ?? bmoViewPager.presentedPageIndex) - 1
        if nextIndex < 0 {
            if self.infinitScroll {
                nextIndex = pageCount - 1
            } else {
                return nil
            }
        }
        if let vc = bmoViewPager.getReferencePageViewController(at: nextIndex) {
            return vc
        }
        guard let vc = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        bmoViewPager.setReferencePageViewController(vc, at: nextIndex)
        vc.view.bmoVP.setIndex(nextIndex)
        vc.view.bmoVP.setOwner(vc)
        return vc
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var nextIndex = (viewController.view.bmoVP.index() ?? bmoViewPager.presentedPageIndex) + 1
        if nextIndex > pageCount - 1 {
            if self.infinitScroll {
                nextIndex = 0
            } else {
                return nil
            }
        }
        if let vc = bmoViewPager.getReferencePageViewController(at: nextIndex) {
            return vc
        }
        guard let vc = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        bmoViewPager.setReferencePageViewController(vc, at: nextIndex)
        vc.view.bmoVP.setIndex(nextIndex)
        vc.view.bmoVP.setOwner(vc)
        return vc
    }
}
