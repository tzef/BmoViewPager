//
//  TargetLineHightlighedView.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/7/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class TargetLineHightlighedView: UIView {
    @IBInspectable var segmentCount: Int = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var targetCount: Int = -1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var progrssFractiion: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var lineColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 5.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if targetCount < 0 { return }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(lineWidth)
        lineColor.setStroke()
        
        let segmentLength = rect.height / CGFloat(max(1, segmentCount - 1))
        let startY = segmentLength * CGFloat(targetCount)
        context.move(to: CGPoint(x: rect.midX, y: startY))
        if progrssFractiion > 0 {
            if progrssFractiion <= 1 {
                context.addLine(to: CGPoint(x: rect.midX, y: startY + segmentLength * progrssFractiion))
            } else {
                context.addLine(to: CGPoint(x: rect.midX, y: startY - segmentLength * (2 - progrssFractiion)))
            }
        } else {
            if progrssFractiion >= -1 {
                context.addLine(to: CGPoint(x: rect.midX, y: startY - segmentLength * abs(progrssFractiion)))
            } else {
                context.addLine(to: CGPoint(x: rect.midX, y: startY + segmentLength * (2 + progrssFractiion)))
            }
        }
        context.strokePath()
    }
}
