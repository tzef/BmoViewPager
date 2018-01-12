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
    func bmoPageItemListLayoutAttributesChanged(_ attributes: [UICollectionViewLayoutAttributes], animated: Bool)
}
class BmoPageItemListLayout: UICollectionViewLayout {
    weak var delegate: BmoPageItemListLayoutDelegate?
    
    var orientation: UIPageViewControllerNavigationOrientation = .horizontal
    var direction: UIUserInterfaceLayoutDirection = .leftToRight
    var attributesList = [UICollectionViewLayoutAttributes]() {
        didSet {
            delegate?.bmoPageItemListLayoutAttributesChanged(attributesList, animated: false)
        }
    }
    var contentSize = CGSize.zero
    var layoutChanged = false
    
    override init() {
        super.init()
    }
    convenience init(orientation: UIPageViewControllerNavigationOrientation, direction: UIUserInterfaceLayoutDirection) {
        self.init()
        self.direction = direction
        self.orientation = orientation
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewLayout
    override var collectionViewContentSize: CGSize {
        return contentSize
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
        guard let cv = collectionView, cv.numberOfItems(inSection: 0) > 0 else {
            attributesList.removeAll()
            contentSize = .zero
            return
        }
        var indexArray: Array<Int> = Array((0..<cv.numberOfItems(inSection: 0)))
        if direction == .rightToLeft && orientation == .horizontal {
            indexArray = Array((0..<cv.numberOfItems(inSection: 0)).reversed())
        }
        if attributesList.count != cv.numberOfItems(inSection: 0) || layoutChanged {
            layoutChanged = false
            var totalLength: CGFloat = 0.0
            attributesList = indexArray.map { (i) -> UICollectionViewLayoutAttributes in
                let size = delegate?.bmoPageItemListLayout(sizeForItemAt: i) ?? CGSize.zero
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                if orientation == .horizontal {
                    attributes.frame = CGRect(origin: CGPoint(x: cv.bounds.minX - cv.contentOffset.x + totalLength, y: 0), size: size)
                } else {
                    attributes.frame = CGRect(origin: CGPoint(x: 0, y: cv.bounds.minY - cv.contentOffset.y + totalLength), size: size)
                }
                if orientation == .horizontal {
                    totalLength += size.width
                } else {
                    totalLength += size.height
                }
                return attributes
            }
            if orientation == .horizontal {
                contentSize = .init(width: totalLength, height: cv.bounds.height)
            } else {
                contentSize = .init(width: cv.bounds.width, height: totalLength)
            }
        }
    }
}
