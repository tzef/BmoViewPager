//
//  UIView+Layout.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

import UIKit
public struct ViewBmoVPProxy<Type> {
    public let base: Type
    public init(_ base: Type) {
        self.base = base
    }
}
public protocol ViewBmoVPCompatible {
    var bmoVP: ViewBmoVPProxy<UIView> { get }
}

extension UIView: ViewBmoVPCompatible {
    public var bmoVP: ViewBmoVPProxy<UIView> {
        get {
            return ViewBmoVPProxy(self)
        }
    }
    
    private struct AssociatedKeys {
        static var BMOviewPagerIndex = "bmo_viewPager_index"
        static var BMOviewPagerOwner = "bmo_viewPager_owner"
    }
    fileprivate var bmo_viewpager_index: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BMOviewPagerIndex) as? Int
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.BMOviewPagerIndex, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    weak fileprivate var bmo_viewpager_owner: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BMOviewPagerOwner) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.BMOviewPagerOwner, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

}

extension ViewBmoVPProxy where Type: UIView {
    public func index() -> Int? {
        return self.base.bmo_viewpager_index
    }
    public func setIndex(_ index: Int) {
        self.base.bmo_viewpager_index = index
    }
    public func ownerVC() -> UIViewController? {
        return self.base.bmo_viewpager_owner
    }
    public func setOwner(_ vc: UIViewController) {
        self.base.bmo_viewpager_owner = vc
    }
    public func autoFit(_ toView: UIView,
                        topView: UIView? = nil,
                        margin: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        base.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .leading, relatedBy: .equal,
                               toItem: toView, attribute: .leading, multiplier: 1.0, constant: margin.left))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .trailing, relatedBy: .equal,
                               toItem: toView, attribute: .trailing, multiplier: 1.0, constant: -1 * margin.right))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .top, relatedBy: .equal,
                               toItem: topView ?? toView, attribute: (topView != nil ? .bottom : .top),
                               multiplier: 1.0, constant: margin.top))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .bottom, relatedBy: .equal,
                               toItem: toView, attribute: .bottom, multiplier: 1.0, constant: -1 * margin.bottom))
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func autoFitTop(_ toView: UIView, height: CGFloat) {
        base.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .leading, relatedBy: .equal,
                               toItem: toView, attribute: .leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .trailing, relatedBy: .equal,
                               toItem: toView, attribute: .trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .top, relatedBy: .equal,
                               toItem: toView, attribute: .top, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: NSLayoutAttribute.height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func fitBottom(_ toView: UIView) {
        base.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: base, attribute: .bottom, relatedBy: .equal,
                               toItem: toView, attribute: .bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
