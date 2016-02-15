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
    
    private var url: NSURL?
    private var operation: NSOperation?
    private let imageLoader = ImageLoader.sharedLoader
    
    func loadImageWithURL(imageURL: NSURL?, placeholderImage: UIImage)  {
        url = imageURL
        guard let existedURL = imageURL else {
            return
        }
    
        operation = imageLoader.loadImageWithURL(existedURL) { [weak self] data, response, error in
            
            guard let data = data else {
                print(error)
                return
            }
            
            let image = UIImage(data: data)
            if let weakSelf = self {
                weakSelf.performSelectorOnMainThread("updateImage:", withObject: image, waitUntilDone: true)
            }
        }
        if image == nil {
            image = placeholderImage
        }
    }
    
    dynamic private func updateImage(image: UIImage?) {
        if let existImage = image {
            self.image = existImage
        }
        setNeedsDisplay()
    }
    
    func clear() {
        image = nil
        if let imageURL = url {
            imageLoader.stopImageLoading(imageURL)
        }
        operation = nil
        url = nil
    }
    
}