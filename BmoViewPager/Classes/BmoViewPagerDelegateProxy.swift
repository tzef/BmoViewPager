//
//  BmoViewPagerDelegateProxy.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2018/2/13.
//

import UIKit

protocol BmoViewPagerDelegateProxyDataSource: class {
    func setLastContentOffSet(_ point: CGPoint)
    func getLastContentOffSet() -> CGPoint?
    func isBoundChanged() -> Bool
}

class BmoViewPagerDelegateProxy: NSObject {
    weak var viewPager: BmoViewPager?
    weak var forwardDelegate: AnyObject?
    weak var delegate: BmoViewPagerDelegateProxyDataSource?
    
    public init(viewPager: BmoViewPager?, forwardDelegate: AnyObject?, delegate: BmoViewPagerDelegateProxyDataSource?) {
        self.forwardDelegate = forwardDelegate
        self.viewPager = viewPager
        self.delegate = delegate
        super.init()
    }
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        } else if let forward = self.forwardDelegate, forward.responds(to: aSelector) {
            return forward
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        } else if let forward = self.forwardDelegate {
            return forward.responds(to: aSelector)
        } else {
            return super.responds(to: aSelector)
        }
    }
}

extension BmoViewPagerDelegateProxy: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let pager = viewPager else {
            return
        }
        guard delegate?.isBoundChanged() == false else {
            return
        }
        let offSet = delegate?.getLastContentOffSet() ?? scrollView.contentOffset
        if pager.orientation == .horizontal {
            if abs(offSet.x - scrollView.contentOffset.x) > scrollView.bounds.width * 0.7 {
                pager.presentedPageIndex = pager.pageControlIndex
            }
            if scrollView.contentOffset.x == scrollView.bounds.width {
                if let index = scrollView.subviews[safe: 1]?.subviews.first?.bmoVP.index() {
                    pager.pageControlIndex = index
                }
                return
            }
        } else {
            if abs(offSet.y - scrollView.contentOffset.y) > scrollView.bounds.height * 0.7 {
                pager.presentedPageIndex = pager.pageControlIndex
            }
            if scrollView.contentOffset.y == scrollView.bounds.height {
                if let index = scrollView.subviews[safe: 1]?.subviews.first?.bmoVP.index() {
                    pager.pageControlIndex = index
                }
                return
            }
        }
        delegate?.setLastContentOffSet(scrollView.contentOffset)
        var progressFraction: CGFloat = 0.0
        if pager.orientation == .horizontal {
            let originX = scrollView.contentOffset.x
            progressFraction = (originX - scrollView.bounds.width) / scrollView.bounds.width
        } else {
            let originY = scrollView.contentOffset.y
            progressFraction = (originY - scrollView.bounds.height) / scrollView.bounds.height
        }
        var targetIndex = 0
        if progressFraction > 0.0 {
            targetIndex = (progressFraction > 0.5 ? 2 : 1)
        }
        if progressFraction < 0.0 {
            targetIndex = (progressFraction < -0.5 ? 0 : 1)
        }
        if let index = scrollView.subviews[safe: targetIndex]?.subviews.first?.bmoVP.index() {
            pager.pageControlIndex = index
        }
        pager.delegate?.bmoViewPagerDelegate?(pager, scrollProgress: progressFraction, index: pager.pageControlIndex)
        pager.navigationBars.forEach { (weakBar: WeakBmoVPbar<BmoViewPagerNavigationBar>) in
            if let bar = weakBar.bar {
                bar.updateFocusProgress(&progressFraction)
            }
        }
    }
}
