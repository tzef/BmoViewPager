//
//  TargetLineView.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/26.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class TargetLineView: UIView {
    @IBInspectable var strokeColor: UIColor = UIColor.gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var fillColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 5.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var endTop: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var endBottom: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var fillFraction: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(lineWidth)
        
        var topY = rect.minY
        var endY = rect.maxY
        if endTop {
            topY = rect.midY + lineWidth
        }
        if endBottom {
            endY = rect.midY - lineWidth
        }
        strokeColor.setStroke()
        strokeColor.setFill()
        context.move(to: CGPoint(x: rect.midX, y: topY))
        context.addLine(to: CGPoint(x: rect.midX, y: endY))
        context.strokePath()
        context.fillEllipse(in: CGRect(origin: CGPoint(x: rect.midX - lineWidth, y: rect.midY - lineWidth),
                                       size: CGSize(width: lineWidth * 2, height: lineWidth * 2)))
        
        fillColor.setFill()
        let circleWidth = lineWidth + lineWidth * fillFraction
        context.fillEllipse(in: CGRect(origin: CGPoint(x: rect.midX - circleWidth / 2, y: rect.midY - circleWidth / 2),
                                       size: CGSize(width: circleWidth, height: circleWidth)))
        
        
    }
}
