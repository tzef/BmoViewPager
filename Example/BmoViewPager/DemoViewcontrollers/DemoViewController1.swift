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

    private var contentOffsetObserver: NSKeyValueObservation?

    deinit {
        contentOffsetObserver?.invalidate()
        contentOffsetObserver = nil
    }

    var  customPage1 = ImageViewController(image: #imageLiteral(resourceName: "item0.jpg"))
    var  customPage2 = ImageViewController(image: #imageLiteral(resourceName: "item1.jpg"))
    var  customPage3 = ImageViewController(image: #imageLiteral(resourceName: "item2.jpg"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewPager.dataSource = self
        customViewPgareNavigationBar.viewPager = customViewPager
        customViewPgareNavigationBar.isInterpolationAnimated = true
        
        defaultViewPager.dataSource = self
        defaultViewPager.presentedPageIndex = 7
        defaultViewPagerNavigationBar.edgeMaskPercentage = 0.3
        defaultViewPagerNavigationBar.viewPager = defaultViewPager
        
        if #available(iOS 9.0, *) {
            customPage1.loadViewIfNeeded()
            customPage2.loadViewIfNeeded()
            customPage3.loadViewIfNeeded()
        } else {
        }
        
        customViewPager.setReferencePageViewController(customPage1, at: 0)
        customViewPager.setReferencePageViewController(customPage2, at: 1)
        customViewPager.setReferencePageViewController(customPage3, at: 2)

        self.contentOffsetObserver = defaultViewPagerNavigationBar.observe(\.contentOffset, options: [.new], changeHandler: { (collectionView, value) in
            guard let offset = value.newValue else { return }
            print("DEBUG: offset of navigaion bar \(offset)")
        })
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
            switch page {
            case 0:
                return customPage1
            case 1:
                return customPage2
            case 2:
                return customPage3
            default:
                return UIViewController()
            }
        } else {
            return NumberViewController(number: page)
        }
    }
}
