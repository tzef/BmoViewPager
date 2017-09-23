//
//  String+Size.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

extension String {
    func size(attribute: [NSAttributedStringKey : Any], size: CGSize) -> CGSize {
        let attributedText = NSAttributedString(string: self, attributes: attribute)
        return attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
}
