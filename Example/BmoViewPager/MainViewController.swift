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
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.delegate = self
        viewPager.dataSource = self
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }
}

extension MainViewController: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 3
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerPage1") as? ViewControllerPage1 {
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerPage2") as? ViewControllerPage2 {
                return vc
            }
        case 2:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerPage3") as? ViewControllerPage3 {
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
}

extension MainViewController: BmoViewPagerDelegate {
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        pageControl.currentPage = page
    }
}
