//
//  ViewControllerPage3.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/7/16.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

class ViewControllerPage3: UIViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.delegate = self
        viewPager.dataSource = self
    }
}

extension ViewControllerPage3: BmoViewPagerDelegate {
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        pageControl.currentPage = page
    }
}

extension ViewControllerPage3: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        pageControl.numberOfPages = 11
        return 11
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = NumberViewController(number: page)
        vc.view.backgroundColor = UIColor.darkGray
        return vc
    }
}
