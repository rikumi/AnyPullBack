//
//  ScaleInAnimator.swift
//  AnyPullBack
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017 Vhyme Riku. All rights reserved.
//

import UIKit

// Animator for pushing view controllers.
public class ScaleInAnimator: NSObject, PushAnimator {
    
    internal var sourceRect: CGRect
    
    internal var sourceView: UIView?
    
    public init (sourceRect: CGRect, sourceView: UIView? = nil) {
        self.sourceRect = sourceRect
        self.sourceView = sourceView
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view else { return }
        
        let container = transitionContext.containerView
        
        // Layer order: Bottom <- [ from view / mask view / to view / white box ] -> Top
        // source view is initially in container, so add the other 3 views here
        
        // Add mask view
        let maskView = UIView()
        maskView.frame = container.frame
        maskView.backgroundColor = .black
        maskView.alpha = 0
        container.addSubview(maskView)
        
        // Add destination view
        toView.frame = container.frame
        toView.alpha = 0
        container.addSubview(toView)
        
        // Add white box
        let whiteBox = UIView()
        whiteBox.frame = sourceRect
        whiteBox.backgroundColor = .white
        container.addSubview(whiteBox)
        
        // Add image view containing a fake capture of the source view
        let fakeSourceView = UIImageView()
        
        if let sourceView = sourceView {
            whiteBox.layer.cornerRadius = sourceView.layer.cornerRadius
            whiteBox.clipsToBounds = true
            
            UIGraphicsBeginImageContextWithOptions(sourceView.bounds.size, false, UIScreen.main.scale)
            sourceView.drawHierarchy(in: sourceView.bounds, afterScreenUpdates: true)
            fakeSourceView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            fakeSourceView.frame = CGRect(origin: .zero, size: sourceView.frame.size)
            fakeSourceView.alpha = 1
        }
        whiteBox.addSubview(fakeSourceView)
        
        // Backup the original transform
        let originalTransform = fromView.transform
        
        // Animate cornerRadius
        if whiteBox.layer.cornerRadius != 0 {
            let anim = CABasicAnimation(keyPath: "cornerRadius")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            anim.fromValue = whiteBox.layer.cornerRadius
            anim.toValue = 0
            anim.duration = self.transitionDuration(using: transitionContext)
            whiteBox.layer.add(anim, forKey: "cornerRadius")
            whiteBox.layer.cornerRadius = 0
        }
        
        // White box fade in / mask view fade in / from view scale out
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            let oldWFrame = whiteBox.frame
            let oldTFrame = toView.frame
            
            whiteBox.alpha = 1
            whiteBox.frame = CGRect(x: oldTFrame.minX, y: oldWFrame.minY, width: oldTFrame.width, height: oldWFrame.height)
            maskView.alpha = 0.8
            fakeSourceView.alpha = 0
            fakeSourceView.frame = fakeSourceView.frame.offsetBy(dx: oldWFrame.minX - oldTFrame.minX, dy: 0)
            fromView.transform = originalTransform.scaledBy(x: 0.93, y: 0.93)
            
        }, completion: { finished1 in
            
            // White box scale in
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                
                whiteBox.frame = toView.frame
                
            }, completion: { finished2 in
                
                // Destination view appear
                toView.alpha = 1
                
                // White box fade out
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                    
                    whiteBox.alpha = 0
                    
                }, completion: { finished3 in
                    
                    // Restore the original transform
                    fromView.transform = originalTransform
                    transitionContext.completeTransition(finished1 && finished2 && finished3)
                    
                })
                
            })
            
        })
        
    }
}
