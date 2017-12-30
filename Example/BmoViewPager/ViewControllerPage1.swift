//
//  ViewControllerPage1.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class ViewControllerPage1: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.view.bounds.height > 600 {
            scrollView.isScrollEnabled = false
        }
    }

    @IBAction func moreDemoAction(_ sender: Any) {
        (self.parent?.parent as? DemoViewController)?.viewPager.presentedPageIndex = 1
    }
}
