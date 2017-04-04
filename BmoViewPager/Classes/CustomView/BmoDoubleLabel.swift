//
//  BmoDoubleLabel.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/3.
//
//

import UIKit

class BmoDoubleLabel: UILabel {
    let focusLabel = UILabel()
    var focusColor = UIColor.black {
        didSet {
            focusLabel.textColor = focusColor
            self.setNeedsDisplay()
        }
    }
    let maskLayer = CAShapeLayer()
    var maskProgress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override var text: String? {
        didSet {
            focusLabel.text = text
        }
    }
    override var textAlignment: NSTextAlignment {
        didSet {
            focusLabel.textAlignment = textAlignment
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
        self.addSubview(focusLabel)
        focusLabel.layout.autoFit(self)
        focusLabel.textColor = focusColor
        focusLabel.layer.mask = maskLayer
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if maskProgress > 0 {
            maskLayer.path = CGPath(rect: .init(origin: .zero,
                                                size: .init(width: rect.width * maskProgress, height: rect.height)), transform: nil)
        } else if maskProgress < 0 {
            maskLayer.path = CGPath(rect: .init(origin: .init(x: rect.width * abs(maskProgress), y: 0),
                                                size: .init(width: rect.width * 1 - abs(maskProgress), height: rect.height)), transform: nil)
        } else {
            maskLayer.path = CGPath(rect: CGRect.zero, transform: nil)
        }
    }
}
