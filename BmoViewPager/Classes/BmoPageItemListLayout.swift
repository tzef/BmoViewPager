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
    func bmoPageItemListLayoutAttributesChanged(_ attributes: [UICollectionViewLayoutAttributes])
}
class BmoPageItemListLayout: UICollectionViewLayout {
    weak var delegate: BmoPageItemListLayoutDelegate?
    var orientation: UIPageViewControllerNavigationOrientation = .horizontal
    var attributesList = [UICollectionViewLayoutAttributes]() {
        didSet {
            delegate?.bmoPageItemListLayoutAttributesChanged(attributesList)
        }
    }
    var totalLength: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    convenience init(orientation: UIPageViewControllerNavigationOrientation) {
        self.init()
        self.orientation = orientation
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewLayout
    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else {
            return CGSize.zero
        }
        if totalLength == 0 {
            for i in 0..<cv.numberOfItems(inSection: 0) {
                if orientation == .horizontal {
                    totalLength += delegate?.bmoPageItemListLayout(sizeForItemAt: i).width ?? 0
                } else {
                    totalLength += delegate?.bmoPageItemListLayout(sizeForItemAt: i).height ?? 0
                }
            }
        }
        if orientation == .horizontal {
            return CGSize(width: totalLength, height: cv.bounds.height)
        } else {
            return CGSize(width: cv.bounds.width, height: totalLength)
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList.filter { (layoutAttribute) -> Bool in
            return rect.intersects(layoutAttribute.frame)
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
    override func prepare() {
        super.prepare()
        if attributesList.count == 0 {
            guard let cv = collectionView, cv.numberOfItems(inSection: 0) > 0 else {
                return
            }
            attributesList = (0..<cv.numberOfItems(inSection: 0)).map { (i) -> UICollectionViewLayoutAttributes in
                var beforeDistance: CGFloat = 0
                for j in 0..<i {
                    if orientation == .horizontal {
                        beforeDistance += delegate?.bmoPageItemListLayout(sizeForItemAt: j).width ?? 0
                    } else {
                        beforeDistance += delegate?.bmoPageItemListLayout(sizeForItemAt: j).height ?? 0
                    }
                }
                let size = delegate?.bmoPageItemListLayout(sizeForItemAt: i) ?? CGSize.zero
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                if orientation == .horizontal {
                    attributes.frame = CGRect(origin: CGPoint(x: cv.bounds.minX - cv.contentOffset.x + beforeDistance, y: 0),
                                              size: CGSize(width: size.width, height: cv.bounds.height))
                } else {
                    attributes.frame = CGRect(origin: CGPoint(x: 0, y: cv.bounds.minY - cv.contentOffset.y + beforeDistance),
                                              size: CGSize(width: cv.bounds.width, height: size.height))
                }
                return attributes
            }
        }
    }
}
