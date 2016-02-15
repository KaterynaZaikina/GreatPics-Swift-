//
//  InstaListTableViewCell.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/15/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit

extension InstaListTableViewCell {
    
    static var reuseIdentifier: String {
        return String(self)
    }
    
}

class InstaListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var instaImageView: InstaPostView!
    @IBOutlet weak var instaTextLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        instaImageView.clear()
    }
    
}
