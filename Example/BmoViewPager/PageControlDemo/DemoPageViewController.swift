//
//  DemoPageViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/7/16.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class DemoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var controllers = [UIViewController]()
    var nowPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...10 {
            let vc = NumberViewController(number: i)
            vc.view.backgroundColor = .darkGray
            controllers.append(vc)
        }
        self.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nowPage = controllers.index(of: viewController) ?? controllers.count - 1
        if nowPage + 1 >= controllers.count {
            return nil
        }
        return controllers[nowPage + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nowPage = controllers.index(of: viewController) ?? 0
        if nowPage - 1 < 0 {
            return nil
        }
        return controllers[nowPage - 1]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return nowPage
    }
}
