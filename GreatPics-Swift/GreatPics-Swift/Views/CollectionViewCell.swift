//
//  CollectionViewCell.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import UIKit

extension CollectionViewCell {

    static var reuseIdentifier: String {
        return String(self)
    }
    
}

final public class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: InstaPostView!
    @IBOutlet weak var textLabel: UILabel!
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        imageView.clear()
    }
    
}