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
    @IBOutlet weak var viewPgerListView: SegmentedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.pageListContainerView = viewPgerListView
        viewPager.pageListAutoFocus = false
        viewPager.infinitScroll = true
        viewPager.dataSource = self
    }
}

extension DemoViewController2: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceAttributedTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSForegroundColorAttributeName : viewPgerListView.strokeColor
        ]
    }
    func bmoViewPagerDataSourceHighlightedAttributedTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSForegroundColorAttributeName : UIColor.white
        ]
    }
    func bmoViewPagerDataSourceTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> String? {
        return "Tab \(page)"
    }
    func bmoViewPagerDataSourceListItemSize(_ viewPager: BmoViewPager, forPageListAt page: Int) -> CGSize {
        return CGSize(width: viewPgerListView.bounds.width / 4, height: viewPgerListView.bounds.height)
    }
    func bmoViewPagerDataSourceListItemHighlightedBackgroundView(_ viewPager: BmoViewPager, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = viewPgerListView.strokeColor
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
