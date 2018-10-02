//
//  ViewControllerPage2.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

private let mainColor = UIColor(red: 1.0/255.0, green: 55.0/255.0, blue: 132.0/255.0, alpha: 1.0)
class ViewControllerPage2: UIViewController {
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var viewPager: BmoViewPager!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        viewPagerNavigationBar.autoFocus = false
        viewPagerNavigationBar.viewPager = viewPager
        
        viewPager.layer.borderWidth = 1.0
        viewPager.layer.cornerRadius = 5.0
        viewPager.layer.masksToBounds = true
        viewPager.layer.borderColor = UIColor.white.cgColor
    }
}

extension ViewControllerPage2: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor : UIColor.groupTableViewBackground
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor : mainColor
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UnderLineView()
        view.marginX = 8.0
        view.lineWidth = 5.0
        view.strokeColor = mainColor
        return view
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return "Demo \(page)"
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController0") as? DemoViewController0 {
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController1") as? DemoViewController1 {
                return vc
            }
        case 2:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController2") as? DemoViewController2 {
                return vc
            }
        case 3:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController3") as? DemoViewController3 {
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
}
