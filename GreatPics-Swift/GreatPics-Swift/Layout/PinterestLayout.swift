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

final public class PinterestLayout: UICollectionViewLayout {
    
    var delegate: PinterestLayoutDelegate!
    var cache = [UICollectionViewLayoutAttributes]()
    
    private var numberOfColumns: Int {
        let maxColumns = Int(ceil(contentWidth / maxColumnWidth))
        return min(maxColumns, 4)
        
    }
    private var cellPadding: CGFloat = 6.0
    private var maxColumnWidth: CGFloat = 319.0
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    //MARK: - Override public methods
    override public func prepareLayout() {
        cache.removeAll()
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            let width = columnWidth - 4 * cellPadding
            let photoHeight = columnWidth
            let annotationHeight = delegate.collectionView(collectionView!,
                heightForCommentAtIndexPath: indexPath, withWidth: width)
            let height = photoHeight + annotationHeight + 2 * cellPadding
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            
            if let minElement = yOffset.minElement(), let index = yOffset.indexOf(minElement) {
                column = index
            } else {
                column = 0
            }
        }
    }
    
    override public func collectionViewContentSize() -> CGSize {
       
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache
    }
    
}
