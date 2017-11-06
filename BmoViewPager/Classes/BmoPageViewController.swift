//
//  BmoPageViewController.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

class BmoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    weak var scrollViewDelegate: UIScrollViewDelegate?
    weak var bmoDataSource: BmoViewPagerDataSource?
    weak var bmoViewPager: BmoViewPager!
    weak var pageScrollView: UIScrollView?
    fileprivate var setViewControllerIng = false
    var infinitScroll: Bool = false
    var scrollable: Bool = true {
        didSet {
            pageScrollView?.isScrollEnabled = scrollable
        }
    }
    var pageCount = 0
    
    init(_ orientation: UIPageViewControllerNavigationOrientation) {
        super.init(transitionStyle: .scroll, navigationOrientation: orientation, options: nil)
    }
    convenience init(viewPager: BmoViewPager, scrollDelegate: UIScrollViewDelegate?,
                     orientation: UIPageViewControllerNavigationOrientation = .horizontal) {
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
    func findScrollViewIfNeed() {
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
    func setPageViewController() {
        let count = bmoDataSource?.bmoViewPagerDataSourceNumberOfPage(in: bmoViewPager) ?? 1
        if count == 0 {
            return
        }
        pageCount = count
        if let firstVC = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: bmoViewPager.presentedPageIndex) {
            self.delegate = self
            self.dataSource = self
            firstVC.view.bmoVP.setOwner(firstVC)
            firstVC.view.bmoVP.setIndex(bmoViewPager.presentedPageIndex)
            setViewControllerIng = true
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: { [weak self] (finished) in
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
    func reloadData() {
        self.setPageViewController()
    }
    func setViewPagerPage(_ page: Int) {
        if setViewControllerIng { return }
        if page >= pageCount { return }
        if let vc = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: page) {
            setViewControllerIng = true
            self.setViewControllers([vc], direction: .forward, animated: false, completion: { [weak self] (finished) in
                self?.setViewControllerIng = false
            })
            bmoViewPager.delegate?.bmoViewPagerDelegate?(bmoViewPager, didAppear: vc, page: page)
            vc.view.bmoVP.setIndex(page)
            vc.view.bmoVP.setOwner(vc)
        }
    }
    func setViewPagerPage(withViewController vc: UIViewController, at page: Int) {
        if setViewControllerIng { return }
        if page >= pageCount { return }
        setViewControllerIng = true
        self.setViewControllers([vc], direction: .forward, animated: false, completion: { [weak self] (finished) in
            self?.setViewControllerIng = false
        })
        bmoViewPager.delegate?.bmoViewPagerDelegate?(bmoViewPager, didAppear: vc, page: page)
        vc.view.bmoVP.setIndex(page)
        vc.view.bmoVP.setOwner(vc)
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
        guard let vc = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
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
        guard let vc = bmoDataSource?.bmoViewPagerDataSource(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        vc.view.bmoVP.setIndex(nextIndex)
        vc.view.bmoVP.setOwner(vc)
        return vc
    }
}
