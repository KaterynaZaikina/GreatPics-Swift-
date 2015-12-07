//
//  DetailImageController.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 12/4/15.
//  Copyright © 2015 kateryna.zaikina. All rights reserved.
//

import Foundation
import UIKit

class DetailImageController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var image: InstaPostView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var postImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = postImageURL {
            self.image.loadImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder.png")!)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    @IBAction func handleDoubleTap(sender: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let pointInView = sender.locationOfTouch(0, inView: scrollView)
            let scrollViewSize = scrollView.bounds.size
            let zoomScale: CGFloat = 2
            let width = scrollViewSize.width / zoomScale
            let height = scrollViewSize.height / zoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            
            let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
            scrollView.zoomToRect(rectToZoomTo, animated: true)
        }
    }
    
}