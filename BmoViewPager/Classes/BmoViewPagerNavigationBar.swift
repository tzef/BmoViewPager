//
//  BmoViewPagerNavigationBar.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/6/17.
//
//

import UIKit

@IBDesignable
public class BmoViewPagerNavigationBar: UIView {
    public weak var viewPager: BmoViewPager? {
        didSet {
            if let viewPager = viewPager, inited == true {
                self.resetViewPager(viewPager)
            }
        }
    }
    
    /// enable auto focus, will find the nearest center position for next item
    public var autoFocus: Bool = true {
        didSet {
            pageListView?.autoFocus = autoFocus
        }
    }
    
    weak var pageViewController: BmoPageViewController?
    fileprivate weak var pageListView: BmoPageItemList?
    fileprivate var inited = false
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if inited == false {
            inited = true
            if let viewPager = viewPager {
                self.resetViewPager(viewPager)
            }
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.viewPager != nil { return }
        let str1 = "BMO ViewPager NavigationBar"
        let str2 = "Need to assign a BmoViewPager"
        let mainAttributed = [
            NSForegroundColorAttributeName  : UIColor.black,
            NSFontAttributeName             : UIFont.boldSystemFont(ofSize: 24.0),
            ]
        let subAttributed = [
            NSForegroundColorAttributeName  : UIColor.lightGray,
            NSFontAttributeName             : UIFont.boldSystemFont(ofSize: 17.0),
            ]
        let str1Size = str1.bmoVP.size(attribute: mainAttributed, size: .zero)
        let str2Size = str2.bmoVP.size(attribute: subAttributed, size: .zero)
        let totalHeight = str1Size.height + str2Size.height + 8
        let str1Point = CGPoint(x: rect.midX - str1Size.width / 2, y: rect.midY - totalHeight / 2)
        let str2Point = CGPoint(x: rect.midX - str2Size.width / 2, y: str1Point.y + str1Size.height)
        (str1 as NSString).draw(at: str1Point, withAttributes: mainAttributed)
        (str2 as NSString).draw(at: str2Point, withAttributes: subAttributed)
    }
    
    /// if the viewpager position changed by navigation bar, cause the navigatoin position become weird, need to reset contentInset to solve cell wrong position issue
    public func resetContentInset() {
        self.pageListView?.collectionView?.contentInset = .zero
    }
    
    public func reloadData() {
        self.pageListView?.reloadData()
    }
    
    func updateFocusProgress(_ progress: inout CGFloat) {
        self.pageListView?.updateFocusProgress(&progress)
    }
    
    private func resetViewPager(_ viewPager: BmoViewPager) {
        viewPager.navigationBar = self
        
        let itemList = BmoPageItemList(viewPager: viewPager, delegate: self)
        itemList.bmoDataSource = viewPager.dataSource
        itemList.backgroundColor = UIColor.clear
        itemList.autoFocus = autoFocus
        itemList.reloadData()
        
        self.subviews.forEach { (view) in
            if view is BmoPageItemList {
                view.removeFromSuperview()
            }
        }
        self.addSubview(itemList)
        itemList.bmoVP.autoFit(self)
        
        pageListView = itemList
    }
}

extension BmoViewPagerNavigationBar: BmoPageItemListDelegate {
    func bmoViewPageItemList(_ itemList: BmoPageItemList, didSelectItemAt index: Int) {
        guard let viewPager = viewPager else {
            return
        }
        if viewPager.delegate?.bmoViewPagerDelegate?(viewPager, shouldSelect: index) == false {
            return
        }
        var reuseIt = false
        pageViewController?.pageScrollView?.subviews.forEach({ (view) in
            if view.subviews.first?.bmoVP.index() == index {
                reuseIt = true
                pageViewController?.pageScrollView?.setContentOffset(view.frame.origin, animated: true)
            }
        })
        if reuseIt == false {
            viewPager.presentedPageIndex = index
        }
    }
}
