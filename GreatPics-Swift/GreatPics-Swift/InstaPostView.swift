//
//  InstaPostView.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 11/30/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

class InstaPostView: UIImageView {
    
    var realImage: UIImage?
    
    var url: NSURL?
    var operation: NSOperation?
    
    func loadImageWithURL(imageURL: NSURL?, placeholderImage: UIImage)  {
        url = imageURL
       
        
       operation = NetworkingManager(baseURL: nil).loadWithRequest(url!) { (data, response, error) -> Void in
            
            guard let data = data where error == nil else {
                print(error)
                return
            }
            
            let image = UIImage(data: data)
            self.realImage = image
            assert(self.realImage != nil)
            self.performSelectorOnMainThread("updateImage", withObject: nil, waitUntilDone: true)
        }
        
        if realImage == nil {
            self.image = placeholderImage
        }

    }
    
    func updateImage() {
        self.image = self.realImage
        self.setNeedsDisplay()
    }
    
    func clear() {
        image = nil
        realImage = nil
        operation?.cancel()
        operation = nil
        url = nil
    }

}