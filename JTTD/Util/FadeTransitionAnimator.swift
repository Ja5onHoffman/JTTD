//
//  FadeTransition.swift
//  JTTD
//
//  Created by Jason Hoffman on 10/12/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import UIKit

class FadeSegueAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.8
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        let gameViewController = transitionContext.viewController(forKey: .to)!
        let gameView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        
        if let view = gameView {
            containerView.addSubview(view)
        }
        
        gameView?.alpha = 0
        gameView?.layoutIfNeeded()
        
        let finalFrame = transitionContext.finalFrame(for: gameViewController)
        
        UIView.animate(withDuration: duration) {
            gameView?.alpha = 1.0
            gameView?.layoutIfNeeded()
        } completion: { (finished) in
            transitionContext.completeTransition(true)
        }
        
    }
}

class RestoreSegueAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.8
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        let initialVC = transitionContext.viewController(forKey: .to)!
        let initialView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        
        if let view = initialView {
            containerView.addSubview(view)
        }
        
        initialView?.alpha = 0
        initialView?.layoutIfNeeded()
        
        let finalFrame = transitionContext.finalFrame(for: initialVC)
        
        UIView.animate(withDuration: duration) {
            initialView?.alpha = 1.0
            initialView?.layoutIfNeeded()
        } completion: { (finished) in
            transitionContext.completeTransition(true)
        }
        
    }
}


class FadeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeSegueAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RestoreSegueAnimator()
    }
}
