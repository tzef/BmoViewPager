//
//  DemoViewController3.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/5.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

class DemoViewController3: UIViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var viewPagerNavigationBar2: BmoViewPagerNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.dataSource = self
        viewPager.orientation = .vertical
        viewPager.presentedPageIndex = 2
        viewPagerNavigationBar.viewPager = viewPager
        viewPagerNavigationBar2.viewPager = viewPager
    }
}

extension DemoViewController3: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> String? {
        return "Tab \(page)"
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return NumberViewController(number: page)
    }
}
