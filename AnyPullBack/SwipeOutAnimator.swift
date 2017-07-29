//
//  SwipeOutAnimator
//  AnyPullBack
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017 Vhyme Riku. All rights reserved.
//

import UIKit

public enum SwipeOutDirection {
    case rightFromLeft
    case leftFromRight
    case downFromTop
    case upFromBottom
}

public var SwipeOutHintText: String = ""

// Animator for popping view controllers.
public class SwipeOutAnimator: NSObject, PopAnimator {
    
    internal var direction: SwipeOutDirection
    
    public init (direction: SwipeOutDirection) {
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
        
        // Layer order: Bottom <- [ destination view / mask view / source view ] -> Top
        // source view is initially in container, so add the other 2 views here
        
        // Add mask view
        let maskView = UIView()
        maskView.frame = container.frame
        maskView.backgroundColor = .black
        maskView.alpha = 0.8
        container.insertSubview(maskView, belowSubview: sourceView)
        
        // Add hint view only when pulling vertically
        var hintView: UILabel?
        if direction == .downFromTop {
            hintView = UILabel()
            hintView!.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: 0)
            maskView.addSubview(hintView!)
        } else if direction == .upFromBottom {
            hintView = UILabel()
            hintView!.frame = CGRect(x: 0, y: container.bounds.height, width: container.bounds.width, height: 0)
            maskView.addSubview(hintView!)
        }
        
        hintView?.textAlignment = .center
        hintView?.textColor = .white
        hintView?.font = UIFont.systemFont(ofSize: 14)
        hintView?.text = SwipeOutHintText
        hintView?.alpha = 0
        
        // Add destination view
        destinationView.frame = container.frame
        let originalTransform = destinationView.transform
        destinationView.transform = originalTransform.scaledBy(x: 0.93, y: 0.93)
        container.insertSubview(destinationView, belowSubview: maskView)
        
        // Calculate frame
        var destFrame = sourceView.frame
        switch direction {
        case .rightFromLeft:
            destFrame = destFrame.offsetBy(dx: destFrame.width, dy: 0)
        case .leftFromRight:
            destFrame = destFrame.offsetBy(dx: -destFrame.width, dy: 0)
        case .downFromTop:
            destFrame = destFrame.offsetBy(dx: 0, dy: destFrame.height)
        case .upFromBottom:
            destFrame = destFrame.offsetBy(dx: 0, dy: -destFrame.height)
        }
        
        // Mask view fade out / source view slide out / destination view scale in
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            
            maskView.alpha = 0
            sourceView.frame = destFrame
            destinationView.transform = originalTransform
            hintView?.frame = container.bounds
            hintView?.alpha = 1
            
        }, completion: { _ in
            
            let cancelled = transitionContext.transitionWasCancelled
            
            if cancelled {
                destinationView.transform = originalTransform
                maskView.removeFromSuperview()
                destinationView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!cancelled)
            
        })
        
    }
}
