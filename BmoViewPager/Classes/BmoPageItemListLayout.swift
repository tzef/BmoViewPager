//
//  BmoPageItemListFlowLayout.swift
//  ETNews
//
//  Created by LEE ZHE YU on 2017/4/20.
//  Copyright © 2017年 Sen Informatoin co. All rights reserved.
//

import UIKit

protocol BmoPageItemListLayoutDelegate: class {
    func bmoPageItemListLayout(sizeForItemAt index: Int) -> CGSize
}
class BmoPageItemListLayout: UICollectionViewLayout {
    weak var delegate: BmoPageItemListLayoutDelegate?
    var attributesList = [UICollectionViewLayoutAttributes]()
    var totalWidth: CGFloat = 0.0
    
    // MARK: UICollectionViewLayout
    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else {
            return CGSize.zero
        }
        if totalWidth == 0 {
            for i in 0..<cv.numberOfItems(inSection: 0) {
                totalWidth += delegate?.bmoPageItemListLayout(sizeForItemAt: i).width ?? 0
            }
        }
        return CGSize(width: totalWidth, height: cv.bounds.height)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func prepare() {
        super.prepare()
        if attributesList.count == 0 {
            guard let cv = collectionView, cv.numberOfItems(inSection: 0) > 0 else {
                return
            }
            attributesList = (0..<cv.numberOfItems(inSection: 0)).map { (i) -> UICollectionViewLayoutAttributes in
                var beforeWidth: CGFloat = 0
                for j in 0..<i {
                    beforeWidth += delegate?.bmoPageItemListLayout(sizeForItemAt: j).width ?? 0
                }
                let size = delegate?.bmoPageItemListLayout(sizeForItemAt: i) ?? CGSize.zero
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                attributes.frame = CGRect(origin: CGPoint(x: cv.bounds.minX - cv.contentOffset.x + beforeWidth, y: 0),
                                          size: CGSize(width: size.width, height: cv.bounds.height))
                return attributes
            }
        }
    }
}
