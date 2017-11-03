//
//  BmoDoubleLabel.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/3.
//
//

import UIKit

class BmoDoubleLabel: UILabel {
    let foreLabel = UILabel()
    var foreColor = UIColor.black {
        didSet {
            foreLabel.textColor = foreColor
            self.setNeedsDisplay()
        }
    }
    let foreMaskLayer = CAShapeLayer()
    
    let rearLabel = UILabel()
    let rearMaskLayer = CAShapeLayer()
    
    var rearView = UIView()
    var foreView = UIView()
    
    var orientation: UIPageViewControllerNavigationOrientation = .horizontal
    var maskProgress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override var text: String? {
        didSet {
            if text != nil {
                foreLabel.text = text
                rearLabel.text = text
                self.text = nil
            }
        }
    }
    override var font: UIFont! {
        didSet {
            foreLabel.font = font
            rearLabel.font = font
        }
    }
    override var textColor: UIColor! {
        didSet {
            rearLabel.textColor = textColor
        }
    }
    override var textAlignment: NSTextAlignment {
        didSet {
            foreLabel.textAlignment = textAlignment
            rearLabel.textAlignment = textAlignment
        }
    }
    var rearAttributedText: NSAttributedString? {
        didSet {
            rearLabel.attributedText = rearAttributedText
        }
    }
    var foreAttributedText: NSAttributedString? {
        didSet {
            foreLabel.attributedText = foreAttributedText
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        self.addSubview(rearView)
        rearView.backgroundColor = UIColor.clear
        rearView.layer.mask = rearMaskLayer
        rearView.bmoVP.autoFit(self)
        rearView.addSubview(rearLabel)
        rearLabel.backgroundColor = UIColor.clear
        rearLabel.bmoVP.autoFit(rearView)
        
        self.addSubview(foreView)
        foreView.backgroundColor = UIColor.clear
        foreView.layer.mask = foreMaskLayer
        foreView.bmoVP.autoFit(self)
        foreView.addSubview(foreLabel)
        foreLabel.backgroundColor = UIColor.clear
        foreLabel.bmoVP.autoFit(foreView)
    }
    func setRearBackgroundView(_ view: UIView) {
        rearView.subviews.forEach { (view) in
            if view is UILabel == false {
                view.removeFromSuperview()
            }
        }
        rearView.insertSubview(view, at: 0)
        view.bmoVP.autoFit(rearView)
    }
    func setForeBackgroundView(_ view: UIView) {
        foreView.subviews.forEach { (view) in
            if view is UILabel == false {
                view.removeFromSuperview()
            }
        }
        foreView.insertSubview(view, at: 0)
        view.bmoVP.autoFit(foreView)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if maskProgress == 1.0 {
            foreMaskLayer.path = CGPath(rect: rect, transform: nil)
            rearMaskLayer.path = CGPath(rect: CGRect.zero, transform: nil)
        } else if maskProgress > 0 {
            if orientation == .horizontal {
                foreMaskLayer.path = CGPath(rect: .init(origin: .zero,
                                                        size: .init(width: rect.width * maskProgress, height: rect.height)),
                                            transform: nil)
                rearMaskLayer.path = CGPath(rect: .init(origin: .init(x: rect.width * abs(maskProgress), y: 0),
                                                        size: .init(width: rect.width * 1 - abs(maskProgress), height: rect.height)),
                                            transform: nil)
            } else {
                foreMaskLayer.path = CGPath(rect: .init(origin: .zero,
                                                        size: .init(width: rect.width, height: rect.height * maskProgress)),
                                            transform: nil)
                rearMaskLayer.path = CGPath(rect: .init(origin: .init(x: 0, y: rect.height * abs(maskProgress)),
                                                        size: .init(width: rect.width, height: rect.height * 1 - abs(maskProgress))),
                                            transform: nil)
            }
        } else if maskProgress < 0 {
            if orientation == .horizontal {
                foreMaskLayer.path = CGPath(rect: .init(origin: .init(x: rect.width * abs(maskProgress), y: 0),
                                                        size: .init(width: rect.width * 1 - abs(maskProgress), height: rect.height)),
                                            transform: nil)
                rearMaskLayer.path = CGPath(rect: .init(origin: .zero,
                                                        size: .init(width: rect.width * abs(maskProgress), height: rect.height)),
                                            transform: nil)
            } else {
                foreMaskLayer.path = CGPath(rect: .init(origin: .init(x: 0, y: rect.height * abs(maskProgress)),
                                                        size: .init(width: rect.width, height: rect.height * 1 - abs(maskProgress))),
                                            transform: nil)
                rearMaskLayer.path = CGPath(rect: .init(origin: .zero,
                                                        size: .init(width: rect.width, height: rect.height * abs(maskProgress))),
                                            transform: nil)
            }
        } else {
            foreMaskLayer.path = CGPath(rect: CGRect.zero, transform: nil)
            rearMaskLayer.path = CGPath(rect: rect, transform: nil)
        }
    }
}
