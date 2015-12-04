//
//  DetailImageController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/4/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

class DetailImageController: UIViewController {

    @IBOutlet weak var image: InstaPostView!
    var postImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = postImageURL {
        self.image.loadImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder.png")!)
        }
    }
    
    
    


}