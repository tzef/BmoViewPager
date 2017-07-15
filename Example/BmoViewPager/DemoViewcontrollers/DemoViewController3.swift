//
//  DemoViewController3.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/5.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BmoViewPager

private let mainColor = UIColor(red: 1.0/255.0, green: 55.0/255.0, blue: 132.0/255.0, alpha: 1.0)
class DemoViewController3: UIViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var viewPagerNavigationBar2: BmoViewPagerNavigationBar!
    @IBOutlet weak var targetHighlightedLine: TargetLineHightlighedView!
    var targetLineViewList = Array<AnyObject?>(repeating: nil, count: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.orientation = .vertical
        viewPager.presentedPageIndex = 2
        viewPagerNavigationBar.viewPager = viewPager
        viewPagerNavigationBar.orientation = .vertical
        viewPagerNavigationBar2.viewPager = viewPager
        viewPagerNavigationBar2.orientation = .vertical
        
        
        targetHighlightedLine.segmentCount = 4
        targetHighlightedLine.lineColor = mainColor
    }
}

extension DemoViewController3: BmoViewPagerDelegate {
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, scrollProgress fraction: CGFloat, index: Int) {
        if let view = targetLineViewList[safe: index] as? TargetLineView {
            switch abs(fraction) {
            case 0.0 ... 0.1:
                view.fillFraction = 1 - abs(fraction) / 0.1
            case 0.9 ... 1.0:
                view.fillFraction = (abs(fraction) - 0.9) / 0.1
            default:
                view.fillFraction = 0.0
            }
        }
        targetHighlightedLine.targetCount = index
        if fraction > 0 {
            switch fraction {
            case 0.1 ... 0.9:
                targetHighlightedLine.progrssFractiion = (fraction - 0.1) / 0.4
            default:
                targetHighlightedLine.progrssFractiion = 0.0
                
            }
        } else {
            switch fraction {
            case -0.9 ... -0.1:
                targetHighlightedLine.progrssFractiion = (fraction + 0.1) / 0.4
            default:
                targetHighlightedLine.progrssFractiion = 0.0
            }
        }
    }
}

extension DemoViewController3: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        if navigationBar == viewPagerNavigationBar {
            return "Tab \(page)"
        }
        return nil
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        if navigationBar == viewPagerNavigationBar {
            return CGSize(width: 80, height: viewPagerNavigationBar.bounds.size.height)
        } else {
            return CGSize(width: viewPagerNavigationBar2.bounds.size.width, height: viewPagerNavigationBar2.bounds.size.height / 4)
        }
    }
    func bmoViewPagerDataSourceNaviagtionBarItemNormalBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        if navigationBar == viewPagerNavigationBar2 {
            let view = TargetLineView()
            view.lineWidth = 5.0
            view.fillColor = UIColor.groupTableViewBackground
            view.strokeColor = UIColor.lightGray
            if page == 0 {
                view.endTop = true
            }
            if page == 3 {
                view.endBottom = true
            }
            return view
        }
        return nil
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
            if navigationBar == viewPagerNavigationBar2 {
                if let view = targetLineViewList[safe: page] as? TargetLineView {
                    return view
                } else {
                    let view = TargetLineView()
                    view.lineWidth = 5.0
                    if page == viewPager.presentedPageIndex {
                        view.fillFraction = 1.0
                    }
                    view.fillColor = mainColor
                    view.strokeColor = UIColor.lightGray
                    if page == 0 {
                        view.endTop = true
                    }
                    if page == 3 {
                        view.endBottom = true
                    }
                    targetLineViewList[page] = view
                    return view
                }
            }
            return nil
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return NumberViewController(number: page)
    }
}
