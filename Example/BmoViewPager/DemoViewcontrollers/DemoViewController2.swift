//
//  DemoViewController2.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

class DemoViewController2: UIViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerSegmentedView: SegmentedView!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPagerNavigationBar.viewPager = viewPager
        viewPagerNavigationBar.layer.masksToBounds = true
        viewPagerNavigationBar.layer.cornerRadius = viewPagerSegmentedView.layer.cornerRadius
        viewPager.presentedPageIndex = 1
        viewPager.infinitScroll = true
        viewPager.dataSource = self
    }
}

extension DemoViewController2: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSForegroundColorAttributeName : viewPagerSegmentedView.strokeColor
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSForegroundColorAttributeName : UIColor.white
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return "Tab \(page)"
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(width: navigationBar.bounds.width / 4, height: navigationBar.bounds.height)
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = viewPagerSegmentedView.strokeColor
        return view
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return NumberViewController(number: page)
    }
}
