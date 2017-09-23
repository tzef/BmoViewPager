//
//  DemoViewController1.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

class DemoViewController1: UIViewController {
    @IBOutlet weak var defaultViewPagerNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var defaultViewPager: BmoViewPager!
    @IBOutlet weak var customViewPgareNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var customViewPager: BmoViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewPager.dataSource = self
        customViewPager.isInterporationAnimated = false
        customViewPgareNavigationBar.viewPager = customViewPager
        
        defaultViewPager.dataSource = self
        defaultViewPagerNavigationBar.viewPager = defaultViewPager
    }
}

extension DemoViewController1: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        if viewPager == customViewPager {
            return ""
        } else {
            return "Default \(page)"
        }
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        if viewPager == customViewPager {
            return CGSize(width: navigationBar.bounds.width / 3, height: navigationBar.bounds.height)
        } else {
            return .zero
        }
    }
    func bmoViewPagerDataSourceNaviagtionBarItemNormalBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        if viewPager == customViewPager {
            if let image = UIImage(named: "item\(page)_1.jpg") {
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        if viewPager == customViewPager {
            if let image = UIImage(named: "item\(page)_2.jpg") {
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        if viewPager == customViewPager {
            return 3
        } else {
            return 10
        }
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        if viewPager == customViewPager {
            return ImageViewController(image: UIImage(named: "item\(page).jpg"))
        } else {
            return NumberViewController(number: page)
        }
    }
}
