//
//  MainViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

class MainViewController: UIViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        viewPager.scrollable = false
        
        let navigationBar = BmoViewPagerNavigationBar(frame: CGRect(origin: .zero, size: .init(width: 200, height: 30)))
        self.navigationItem.titleView = navigationBar
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.viewPager = viewPager
    }
}

extension MainViewController: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.strokeWidth     : 1.0,
            NSAttributedString.Key.strokeColor     : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.groupTableViewBackground
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return page == 0 ? "DEMO" : "ABOUT"
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(width: navigationBar.bounds.width / 2, height: navigationBar.bounds.height)
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController") as? DemoViewController {
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController {
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
}
