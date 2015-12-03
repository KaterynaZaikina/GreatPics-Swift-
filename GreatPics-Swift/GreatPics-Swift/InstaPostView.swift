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
    
    var url: NSURL?
    var operation: NSOperation?
    private let imageLoader = ImageLoader()
    
    func loadImageWithURL(imageURL: NSURL?, placeholderImage: UIImage)  {
        url = imageURL
        guard let existedURL = imageURL else {
            return
        }
        
        operation = imageLoader.loadImageWithURL(existedURL) { data, response, error in
            guard let data = data where error == nil else {
                print(error)
                return
            }
            let image = UIImage(data: data)
            self.performSelectorOnMainThread("updateImage:", withObject: image, waitUntilDone: true)
        }
        if image == nil {
            self.image = placeholderImage
        }
    }
    
    func updateImage(image: UIImage?) {
        if let existImage = image {
            self.image = existImage
        }
        self.setNeedsDisplay()
    }
    
    func clear() {
        image = nil
        if let imageURL = url {
            imageLoader.clearImage(imageURL)
        }
        operation = nil
        url = nil
    }
    
}