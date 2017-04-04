//
//  BmoViewPager.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

@objc public protocol BmoViewPagerDataSource {
    func bmoViewPagerNumberOfPage(in viewPager: BmoViewPager) -> Int
    func bmoViewPager(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController
    
    @objc optional func bmoViewPager(_ viewPager: BmoViewPager, titleForPageListAt page: Int) -> String?
}
public class BmoViewPager: UIView, BmoPageItemListDelegate, UIScrollViewDelegate {
    public var pageControlIsHidden = true {
        didSet {
            if pageControlIsHidden {
                pageViewController.removePageControl()
            } else {
                pageViewController.addPageControl()
            }
        }
    }
    public var presentedPageIndex = 0 {
        didSet {
            if pageViewController.presentedIndex != presentedPageIndex {
                pageViewController.setViewPagerPage(presentedPageIndex)
            }
        }
    }
    var pageChanging = false {
        didSet {
            pageListView.listChanging = pageChanging
        }
    }
    var pageListView: BmoPageItemList!
    var pageViewController: BmoPageViewController!
    public var dataSource: BmoViewPagerDataSource? {
        didSet {
            pageViewController.bmoDataSource = dataSource
            pageListView.bmoDataSource = dataSource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    convenience init(initPage: Int) {
        self.init()
        self.presentedPageIndex = initPage
        self.commonInit()
    }
    func commonInit() {
        pageListView = BmoPageItemList(viewPager: self, delegate: self)
        pageViewController = BmoPageViewController(viewPager: self, scrollDelegate: self)
        
        self.addSubview(pageListView)
        pageListView.layout.autoFitTop(self, height: 44)
        
        self.addSubview(pageViewController.view)
        pageViewController.view.layout.autoFit(self, topView: pageListView)
    }
    
    // MARK: - BmoPageItemListDelegate
    func bmoViewPageItemList(_ itemList: BmoPageItemList, didSelectItemAt index: Int) {
        presentedPageIndex = index
        pageListView.progressFraction = 1.0
        pageListView.collectionView.reloadData()
        pageViewController.setViewPagerPage(index)
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originX = scrollView.contentOffset.x
        let progressFraction = (originX - pageViewController.view.bounds.width) / pageViewController.view.bounds.width
        pageListView.updateFocusProgress(progressFraction)
    }
}
