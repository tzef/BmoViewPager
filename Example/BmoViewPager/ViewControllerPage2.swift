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
    @IBOutlet weak var viewPager: BmoViewPager!
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewPager.dataSource = self
        
        viewPager.layer.borderWidth = 1.0
        viewPager.layer.cornerRadius = 5.0
        viewPager.layer.masksToBounds = true
        viewPager.layer.borderColor = UIColor.white.cgColor
    }
}

extension ViewControllerPage2: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceAttributedTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0),
            NSForegroundColorAttributeName : UIColor.groupTableViewBackground
        ]
    }
    func bmoViewPagerDataSourceHighlightedAttributedTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> [String : Any]? {
        return [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0),
            NSForegroundColorAttributeName : mainColor
        ]
    }
    func bmoViewPagerDataSourceListItemHighlightedBackgroundView(_ viewPager: BmoViewPager, forPageListAt page: Int) -> UIView? {
        let view = UnderLineView()
        view.marginX = 8.0
        view.lineWidth = 5.0
        view.strokeColor = mainColor
        return view
    }
    func bmoViewPagerDataSourceTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> String? {
        return "Demo \(page)"
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 3
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController1") as? DemoViewController1 {
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoViewController2") as? DemoViewController2 {
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
}
