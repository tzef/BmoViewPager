//
//  UIView+Layout.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

public struct ViewLayoutProxy<Type> {
    public let base: Type
    public init(_ base: Type) {
        self.base = base
    }
}
public protocol ViewLayoutCompatible {
    var layout: ViewLayoutProxy<UIView> { get }
}

extension UIView: ViewLayoutCompatible {
    public var layout: ViewLayoutProxy<UIView> {
        get {
            return ViewLayoutProxy(self)
        }
    }
}

extension ViewLayoutProxy where Type: UIView {
    public func autoFit(_ toView: UIView) {
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
            NSLayoutConstraint(item: base, attribute: .bottom, relatedBy: .equal,
                               toItem: toView, attribute: .bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
