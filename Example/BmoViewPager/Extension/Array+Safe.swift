//
//  Array+Safe.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/7/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

extension Collection  {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
