//
//  CollectionViewCell.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/26/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: InstaPostView!
    override func prepareForReuse() {
        imageView.clear()
        super.prepareForReuse()
    }

}
