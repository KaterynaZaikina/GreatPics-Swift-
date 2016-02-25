//
//  PushAnimator.swift
//  GreatPics-Swift
//
//  Created by kateryna.zaikina on 2/24/16.
//  Copyright © 2016 kateryna.zaikina. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.5
    private var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 2.0,
            initialSpringVelocity: 0.0,
            options: .CurveLinear,
            animations: {
                fromViewController.view.alpha = 0.5
                toViewController.view.frame = finalFrameForVC
            }, completion: { finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
}
