//
//  DemoButton.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class DemoButton: UIButton {
    @IBInspectable var mainColor = UIColor(red: 1.0/255.0, green: 55.0/255.0, blue: 132.0/255.0, alpha: 1.0)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.setTitleColor(UIColor.white, for: .normal)
        self.setBackgroundImage(mainColor.pixelImage(), for: .normal)
        self.setBackgroundImage(mainColor.darkerColor().pixelImage(), for: .highlighted)
    }
    
    override var intrinsicContentSize: CGSize {
        if let size = self.titleLabel?.text?.size(attribute: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17.0)],
                                                  size: .zero) {
            return CGSize(width: size.width + 16, height: 44.0)
        }
        return super.intrinsicContentSize
    }
}
