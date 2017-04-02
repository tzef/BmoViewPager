//
//  BmoPageViewController.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

class BmoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageViewControllers: [UIViewController]!
    var bmoDataSource: BmoViewPagerDataSource? {
        didSet {
            self.setPageViewController()
        }
    }
    var bmoViewPager: BmoViewPager!
    var presentedIndex = 0
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    convenience init(viewPager: BmoViewPager) {
        self.init()
        self.bmoViewPager = viewPager
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    func setPageViewController() {
        guard let pageCount = bmoDataSource?.bmoViewPagerNumberOfPage(in: bmoViewPager), pageCount > 0 else {
            return
        }
        self.pageViewControllers = Array(repeating: UIViewController(), count: pageCount)
        if let firstVC = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: 0) {
            self.delegate = self
            self.dataSource = self
            self.pageViewControllers[0] = firstVC
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK: - PageViewDelegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        presentedIndex = pageViewControllers.index(of: viewController) ?? presentedIndex
        let nextIndex = presentedIndex - 1
        if nextIndex < 0 {
            return nil
        }
        guard let vc = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        pageViewControllers[nextIndex] = vc
        presentedIndex = nextIndex
        return vc
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        presentedIndex = pageViewControllers.index(of: viewController) ?? presentedIndex
        let nextIndex = presentedIndex + 1
        if nextIndex >= bmoDataSource?.bmoViewPagerNumberOfPage(in: bmoViewPager) ?? 1 {
            return nil
        }
        guard let vc = bmoDataSource?.bmoViewPager(bmoViewPager, viewControllerForPageAt: nextIndex) else {
            return nil
        }
        pageViewControllers[nextIndex] = vc
        presentedIndex = nextIndex
        return vc
    }
}
