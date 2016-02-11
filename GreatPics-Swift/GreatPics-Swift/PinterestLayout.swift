//
//  PinterestLayout.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/11/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
        heightForCommentAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    var delegate: PinterestLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 5.0
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width = columnWidth - 2 * cellPadding
                let annotationHeight = delegate.collectionView(collectionView!,
                    heightForCommentAtIndexPath: indexPath, withWidth: width)
                let height =  width + annotationHeight + 2 * cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache
    }

}
