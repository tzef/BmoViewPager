//
//  SegmentedView.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class SegmentedView: UIView {
    @IBInspectable var strokeColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var segmentedCount: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderColor = strokeColor.cgColor
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let marginX = rect.width / CGFloat(segmentedCount)
        strokeColor.setStroke()
        context.setLineWidth(lineWidth)
        for i in 0...segmentedCount {
            context.move(to: CGPoint(x: rect.minX + marginX * CGFloat(i + 1), y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + marginX * CGFloat(i + 1), y: rect.maxY))
        }
        context.strokePath()
    }
}
