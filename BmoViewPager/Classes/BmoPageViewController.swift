//
//  BmoPageViewController.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

class BmoPageEmptyViewController: UIViewController {
}
class BmoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var scrollViewDelegate: UIScrollViewDelegate?
    var pageViewControllers: [UIViewController]!
    var bmoDataSource: BmoViewPagerDataSource? {
        didSet {
            self.setPageViewController()
        }
    }
    var bmoViewPager: BmoViewPager!
    var willPresentIndex = 0
    var presentedIndex = 0 {
        didSet {
            bmoViewPager.presentedPageIndex = presentedIndex
        }
    }
    var pageCount = 0
    var pageControl: UIPageControl?
    var pageScrollView: UIScrollView?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    convenience init(viewPager: BmoViewPager, scrollDelegate: UIScrollViewDelegate?) {
        self.init()
        self.bmoViewPager = viewPager
        self.scrollViewDelegate = scrollDelegate
        self.view.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subView in self.view.subviews {
            if let scrollView = subView as? UIScrollView {
                self.pageScrollView = scrollView
                scrollView.frame = self.view.bounds
                scrollView.delegate = scrollViewDelegate
            }
            if let pageControl = subView as? UIPageControl {
                pageControl.addObserver(self, forKeyPath: "currentPage", options: [.new], context: nil)
                self.pageControl = pageControl
                if bmoViewPager.pageControlIsHidden {
                    self.removePageControl()
                }
            }
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentPage" {
            if let change = change {
                if let currentPage = (change[NSKeyValueChangeKey.newKey] as AnyObject).uintValue {
                    willPresentIndex = Int(currentPage)
                }
            }
        }
    }
    
    // MARK: - Private
    func setPageViewController() {
        guard let count = bmoDataSource?.bmoViewPagerNumberOfPage(in: bmoViewPager), count > 0 else {
            return
        }
        pageCount = count
        self.pageViewControllers = Array(repeating: BmoPageEmptyViewController(), count: pageCount)
        if let firstVC = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: presentedIndex) {
            self.delegate = self
            self.dataSource = self
            self.pageViewControllers[presentedIndex] = firstVC
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK: - Public
    func removePageControl() {
        self.pageControl?.removeFromSuperview()
    }
    func addPageControl() {
        if let pageControl = self.pageControl {
            self.view.addSubview(pageControl)
        }
    }
    func setViewPagerPage(_ page: Int) {
        presentedIndex = page
        if !(pageViewControllers[page] is BmoPageEmptyViewController) {
            self.setViewControllers([pageViewControllers[page]], direction: .forward, animated: false, completion: nil)
            return
        }
        if let theVC = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: page) {
            self.pageViewControllers[page] = theVC
            self.setViewControllers([theVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK: - PageViewDelegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let nextIndex = (pageViewControllers.index(of: viewController) ?? 0) - 1
        if nextIndex < 0 {
            return nil
        }
        guard let vc = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        pageViewControllers[nextIndex] = vc
        return vc
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = (pageViewControllers.index(of: viewController) ?? pageCount - 1) + 1
        if nextIndex > pageCount - 1 {
            return nil
        }
        guard let vc = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        pageViewControllers[nextIndex] = vc
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        bmoViewPager.pageChanging = true
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            presentedIndex = willPresentIndex
            bmoViewPager.pageChanging = false
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageCount
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return presentedIndex
    }
}
