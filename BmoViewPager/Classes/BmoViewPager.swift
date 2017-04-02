//
//  BmoViewPager.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit

public protocol BmoViewPagerDataSource {
    func bmoViewPager(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController
    func bmoViewPagerNumberOfPage(in viewPager: BmoViewPager) -> Int
}
public class BmoViewPager: UIView {
    var pageViewController: BmoPageViewController!
    public var dataSource: BmoViewPagerDataSource? {
        didSet {
            pageViewController.bmoDataSource = dataSource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        pageViewController = BmoPageViewController(viewPager: self)
        self.addSubview(pageViewController.view)
        pageViewController.view.layout.autoFit(self)
    }
}


