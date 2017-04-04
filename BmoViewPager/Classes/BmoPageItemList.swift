//
//  BmoPageItemList.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/2.
//
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
protocol BmoPageItemListDelegate {
    func bmoViewPageItemList(_ itemList: BmoPageItemList, didSelectItemAt index: Int)
}
class BmoPageItemList: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    let horizontalLayout = UICollectionViewFlowLayout()
    
    var bmoDelegate: BmoPageItemListDelegate!
    var bmoDataSource: BmoViewPagerDataSource? {
        didSet {
            self.setCollectionView()
        }
    }
    var bmoViewPager: BmoViewPager!
    
    var listChanging: Bool = false
    var progressFraction: CGFloat = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(viewPager: BmoViewPager, delegate: BmoPageItemListDelegate) {
        self.init()
        self.bmoDelegate = delegate
        self.bmoViewPager = viewPager
        self.backgroundColor = .white
    }
    func setCollectionView() {
        horizontalLayout.itemSize = .init(width: 100, height: 44.0)
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.minimumInteritemSpacing = 0.0
        horizontalLayout.minimumLineSpacing = 0.0
        horizontalLayout.sectionInset = .zero
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: horizontalLayout)
        collectionView.register(BmoPageItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.addSubview(collectionView)
        collectionView.layout.autoFit(self)
    }
    
    // MARK: - Public
    func updateFocusProgress(_ progress: CGFloat) {
//        print("presented : \(bmoViewPager.presentedPageIndex), progress : \(progress), changing : \(listChanging)")
        if progress > 1.0 {
            self.progressFraction = 0.99
        } else if progress < -1.0 {
            self.progressFraction = -0.99
        } else {
            self.progressFraction = progress
        }
        var reloadIndexs = [IndexPath(row: bmoViewPager.presentedPageIndex, section: 0)]
        if bmoViewPager.presentedPageIndex > 0 {
            reloadIndexs.insert(IndexPath(row: bmoViewPager.presentedPageIndex - 1, section: 0), at: 0)
        }
        if bmoViewPager.presentedPageIndex < (bmoDataSource?.bmoViewPagerNumberOfPage(in: bmoViewPager) ?? 0) - 1{
            reloadIndexs.insert(IndexPath(row: bmoViewPager.presentedPageIndex + 1, section: 0), at: 0)
        }
        self.collectionView.performBatchUpdates({ 
            self.collectionView.reloadItems(at: reloadIndexs)
        }) { (finished) in
        }
    }
    
    // MAKR: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bmoDelegate?.bmoViewPageItemList(self, didSelectItemAt: indexPath.row)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmoDataSource?.bmoViewPagerNumberOfPage(in: bmoViewPager) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BmoPageItemCell else {
            return UICollectionViewCell()
        }
        guard let title = bmoDataSource?.bmoViewPager?(bmoViewPager, titleForPageListAt: indexPath.row) else {
            return cell
        }
        var fraction: CGFloat = 0.0
        
        if listChanging {
            if progressFraction > 0 {
                if indexPath.row == bmoViewPager.presentedPageIndex + 1 {
                    fraction = progressFraction
                }
                if indexPath.row == bmoViewPager.presentedPageIndex {
                    fraction = -1 * progressFraction
                }
            } else {
                if indexPath.row == bmoViewPager.presentedPageIndex - 1 {
                    fraction = -1 * (1 - abs(progressFraction))
                }
                if indexPath.row == bmoViewPager.presentedPageIndex {
                    fraction = 1 - abs(progressFraction)
                }
            }
        } else {
            if indexPath.row == bmoViewPager.presentedPageIndex {
                fraction = 1.0
            }
        }
        cell.configureCell(title: title, focusProgress: fraction)
        return cell
    }
}

class BmoPageItemCell: UICollectionViewCell {
    let titleLabel = BmoDoubleLabel()
    func configureCell(title: String, focusProgress: CGFloat) {
        titleLabel.text = title
        titleLabel.maskProgress = focusProgress
        if self.contentView.subviews.count == 0 {
            self.contentView.addSubview(titleLabel)
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.lightGray
            titleLabel.layout.autoFit(self.contentView)
        }
    }
}
