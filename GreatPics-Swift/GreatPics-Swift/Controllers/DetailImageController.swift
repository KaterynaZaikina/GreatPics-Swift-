//
//  DetailImageController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/4/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static var placeholder: UIImage {
        return UIImage(named: "placeholder.png")!
    }
}

//MARK: - DetailImageController class
final public class DetailImageController: UIViewController {
    
    @IBOutlet private weak var image: InstaPostView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var textLabel: UILabel!
    
    var instaPost: InstaPost?
    var postImageURL: String?
    
    //MARK: - Controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = postImageURL {
            image.loadImageWithURL(NSURL(string: url), placeholderImage: UIImage.placeholder)
        }
        if let instaPost = instaPost {
            textLabel.text = instaPost.text
        }
        
    }
    
    //MARK: - Actions
    @IBAction private func handleDoubleTap(sender: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let pointInView = sender.locationOfTouch(0, inView: scrollView)
            let scrollViewSize = scrollView.bounds.size
            let zoomScale: CGFloat = 2
            
            let width = scrollViewSize.width / zoomScale
            let height = scrollViewSize.height / zoomScale
            
            let zoomOriginX = pointInView.x - (width / 2.0)
            let zoomOriginY = pointInView.y - (height / 2.0)
            
            let rectToZoomTo = CGRect(x: zoomOriginX, y: zoomOriginY, width: width, height: height)
            scrollView.zoomToRect(rectToZoomTo, animated: true)
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension DetailImageController: UIScrollViewDelegate {
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
}