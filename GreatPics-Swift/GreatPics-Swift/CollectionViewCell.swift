//
//  CollectionViewCell.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(self)
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: InstaPostView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.clear()
    }
    
}