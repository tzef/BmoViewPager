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
    @IBOutlet weak var defaultViewPager: BmoViewPager!
    @IBOutlet weak var customViewPager: BmoViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViewPager.dataSource = self
        defaultViewPager.dataSource = self
    }
}

extension DemoViewController1: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> String? {
        if viewPager == customViewPager {
            return ""
        } else {
            return "Default \(page)"
        }
    }
    func bmoViewPagerDataSourceListItemSize(_ viewPager: BmoViewPager, forPageListAt page: Int) -> CGSize {
        if viewPager == customViewPager {
            return CGSize(width: viewPager.bounds.width / 3, height: 30.0)
        } else {
            return .zero
        }
    }
    func bmoViewPagerDataSourceListItemBackgroundView(_ viewPager: BmoViewPager, forPageListAt page: Int) -> UIView? {
        if viewPager == customViewPager {
            if let image = UIImage(named: "item\(page)_1.jpg") {
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    func bmoViewPagerDataSourceListItemHighlightedBackgroundView(_ viewPager: BmoViewPager, forPageListAt page: Int) -> UIView? {
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
            return 5
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
