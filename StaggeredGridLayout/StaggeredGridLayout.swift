//
//  StaggeredGridLayout.swift
//  Rise
//
//  Created by 秋本大介 on 2016/06/06.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit

protocol StaggeredGridLayoutDelegate {
    func heightForImageAtIndexPath(collectionView : UICollectionView,
        indexPath : NSIndexPath,
        width : CGFloat
    ) -> CGFloat
    func heightForBodyAtIndexPath(collectionView : UICollectionView,
        indexPath : NSIndexPath,
        width : CGFloat
    ) -> CGFloat
}

class StaggeredGridLayout: UICollectionViewLayout {

    var delegate: StaggeredGridLayoutDelegate! = nil
    
    var cachedAttributes : Array<UICollectionViewLayoutAttributes> = [];

    var contentHeight : CGFloat = 0.0

    let kNumberOfColumns : Int = 2
    let kCellMargin : CGFloat = 10.0

    // MARK: - Accessor
    func contentWidth() -> CGFloat {
        return CGRectGetWidth(self.collectionView!.bounds) - (self.collectionView!.contentInset.left + self.collectionView!.contentInset.right)
    }

    // MARK: - UICollectionViewLayout

    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(self.contentWidth(), self.contentHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes : Array<UICollectionViewLayoutAttributes> = []
        
        for attribute in self.cachedAttributes {
            if (CGRectIntersectsRect(attribute.frame, rect)) {
                layoutAttributes.append(attribute)
            }
        }

        return layoutAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cachedAttributes[indexPath.item]
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }

    override func prepareLayout() {
        // [1] レイアウト情報をキャッシュ済みの場合は処理を終了する
        if self.cachedAttributes.count > 0 {
            return;
        }
        
        var column : Int = 0

        // [2] セルの幅を計算する
        let totalHorizontalMargin : CGFloat = (kCellMargin * (CGFloat(kNumberOfColumns - 1)))
        let cellWidth : CGFloat = (self.contentWidth() - totalHorizontalMargin) / CGFloat(kNumberOfColumns)
        
        // [3] 「セルの原点 x」の配列を計算する
        var cellOriginXList : Array<CGFloat> = Array<CGFloat>()
        for i in 0..<kNumberOfColumns {
            let originX : CGFloat  = CGFloat(i) * (cellWidth + kCellMargin)
            cellOriginXList.append(originX)
        }

        // [4] カラムごとの「現在計算対象にしているセルの原点 y」を格納した配列を計算する
        var currentCellOriginYList : Array<CGFloat> = Array<CGFloat>()
        for _ in 0..<kNumberOfColumns {
            currentCellOriginYList.append(0.0)
        }

        // [5] 各セルのサイズ・原点座標を計算する
        for item in 0..<self.collectionView!.numberOfItemsInSection(0) {
            let indexPath : NSIndexPath = NSIndexPath(forRow: item, inSection: 0)

            // [6] セルの写真部分・ボディ部分のそれぞれの高さを取得する
            let imageHeight : CGFloat  = self.delegate.heightForImageAtIndexPath(
                self.collectionView!, indexPath: indexPath, width: cellWidth)
            
            let bodyHeight : CGFloat  = self.delegate.heightForBodyAtIndexPath(
                self.collectionView!, indexPath: indexPath, width: cellWidth)
            let cellHeight : CGFloat  = imageHeight + bodyHeight;

            // [7] セルの frame を作成する
            let cellFrame : CGRect = CGRectMake(cellOriginXList[column],
                currentCellOriginYList[column],
                cellWidth,
                cellHeight);

            // [8] StaggeredGridLayoutAttributes オブジェクトを作成して、cachedAttributes プロパティに格納する
            let attributes : StaggeredGridLayoutAttributes = StaggeredGridLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.imageHeight = imageHeight;
            attributes.frame = cellFrame;
            self.cachedAttributes.append(attributes)

            // [9] UICollectionView のコンテンツの高さを計算して contentHeight プロパティに格納する
            self.contentHeight = max(self.contentHeight, CGRectGetMaxY(cellFrame));

            // [10] 次のセルの原点 y を計算する
            currentCellOriginYList[column] = currentCellOriginYList[column] + cellHeight + kCellMargin

            // [11] 次のカラムを決める
            var nextColumn : Int = 0
            var minOriginY : CGFloat = CGFloat.max
            let nsCurrentCellOriginYList : NSArray = NSArray(array: currentCellOriginYList)
            nsCurrentCellOriginYList.enumerateObjectsUsingBlock({ originY, index, stop in
                if (originY.compare(minOriginY) == .OrderedAscending) {
                    minOriginY = CGFloat(originY as! NSNumber);
                    nextColumn = index;
                }
            })
            
            column = nextColumn;
        }
    }
}
