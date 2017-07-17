//
//  PopUpAnimator.swift
//  AnyPullBack
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017年 DreamSpace. All rights reserved.
//

import UIKit

// Animator for pushing view controllers.
internal class PopUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var sourceRect: CGRect
    
    var sourceView: UIView?
    
    init (sourceRect: CGRect, sourceView: UIView? = nil) {
        self.sourceRect = sourceRect
        self.sourceView = sourceView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
        
        // White box fade in / mask view fade in / from view scale out
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            whiteBox.alpha = 1
            maskView.alpha = 0.8
            fakeSourceView.alpha = 0
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
