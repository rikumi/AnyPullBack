//
//  SwipeInAnimator
//  AnyPullBack
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017 Vhyme Riku. All rights reserved.
//

import UIKit

public enum SwipeInDirection {
    case leftFromRight
    case rightFromLeft
    case upFromBottom
    case downFromTop
}

// Animator for popping view controllers.
public class SwipeInAnimator: NSObject, PushAnimator {
    
    internal var direction: SwipeInDirection
    
    public init (direction: SwipeInDirection) {
        self.direction = direction
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from),
            let destinationVC = transitionContext.viewController(forKey: .to),
            let sourceView = sourceVC.view,
            let destinationView = destinationVC.view else { return }
        
        let container = transitionContext.containerView
        
        // Layer order: Bottom <- [ source view / mask view / destination view ] -> Top
        // source view is initially in container, so add the other 2 views here
        
        // Add mask view
        let maskView = UIView()
        maskView.frame = container.frame
        maskView.backgroundColor = .black
        maskView.alpha = 0
        container.addSubview(maskView)
        
        // Calculate frame
        var destFrame = container.bounds
        switch direction {
        case .leftFromRight:
            destFrame = destFrame.offsetBy(dx: destFrame.width, dy: 0)
        case .rightFromLeft:
            destFrame = destFrame.offsetBy(dx: -destFrame.width, dy: 0)
        case .upFromBottom:
            destFrame = destFrame.offsetBy(dx: 0, dy: destFrame.height)
        case .downFromTop:
            destFrame = destFrame.offsetBy(dx: 0, dy: -destFrame.height)
        }
        destinationView.frame = destFrame
        
        // Add destination view
        container.addSubview(destinationView)
        
        let originalTransform = sourceView.transform
        
        // Mask view fade in / source view scale out / destination view slide in
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            maskView.alpha = 1
            sourceView.transform = sourceView.transform.scaledBy(x: 0.93, y: 0.93)
            destinationView.frame = container.bounds
            
        }, completion: { _ in
            
            let cancelled = transitionContext.transitionWasCancelled
            
            sourceView.transform = originalTransform
            
            if cancelled {
                maskView.removeFromSuperview()
                destinationView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!cancelled)
            
        })
        
    }
}
