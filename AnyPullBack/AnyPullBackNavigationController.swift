//
//  ViewController.swift
//  AnyPullBack
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017年 DreamSpace. All rights reserved.
//

import UIKit

class AnyPullBackNavigationController: UINavigationController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    var sourceRect = CGRect.zero
    
    var pullableWidthFromLeft: CGFloat = 0
    
    var canPullFromLeft = true
    
    var canPullFromTop = true
    
    var canPullFromBottom = true
    
    private var sourceView: UIView?
    
    private var dispatchingTo: UIScrollView?
    
    private var interactiveDirection: SwipeDirection?
    
    private var interactionTransition: UIPercentDrivenInteractiveTransition?
    
    private var beginPoint: CGPoint?
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.isNavigationBarHidden = true
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
        
        let frame = view.frame
        sourceRect = CGRect(x: frame.minX, y: 200, width: frame.width, height: 267)
    }
    
    func pushViewController(_ viewController: UIViewController, fromView: UIView, animated: Bool) {
        self.sourceView = fromView
        pushViewController(viewController, animated: true)
    }
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            if let view = sourceView {
                let animator = PopUpAnimator(sourceRect: view.convert(view.bounds, to: self.view), sourceView: view)
                sourceView = nil
                return animator
            } else {
                return PopUpAnimator(sourceRect: sourceRect)
            }
        } else if operation == .pop {
            return SwipeOutAnimator(direction: interactiveDirection ?? .downFromTop)
        }
        return nil
    }
    
    @objc internal func handleGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginPoint = gesture.location(in: view)
        case .changed:
            if interactiveDirection == nil, let beginPoint = beginPoint {
                let currentPoint = gesture.location(in: view)
                let dx = currentPoint.x - beginPoint.x
                let dy = currentPoint.y - beginPoint.y
                
                let pullableWidth = pullableWidthFromLeft
                
                if dx > 20 && canPullFromLeft && (pullableWidth <= 0 || beginPoint.x <= pullableWidth) {
                    interactiveDirection = .rightFromLeft
                } else if dy > 20 && canPullFromTop {
                    interactiveDirection = .downFromTop
                } else if dy < -20 && canPullFromBottom {
                    interactiveDirection = .upFromBottom
                }
                
                if let direction = interactiveDirection {
                    updateDispatch(gesture: gesture, toView: view, inDirection: direction)
                }
            }
            
            if dispatchingTo == nil {
                if beginPoint != nil, let direction = interactiveDirection {
                    if interactionTransition == nil {
                        interactionTransition = UIPercentDrivenInteractiveTransition()
                        popViewController(animated: true)
                    }
                    if let transition = interactionTransition {
                        let translation = gesture.translation(in: view)
                        switch direction {
                        case .rightFromLeft:
                            transition.update(max(0, translation.x / view.bounds.width))
                        case .downFromTop:
                            transition.update(max(0, translation.y / view.bounds.height))
                        case .upFromBottom:
                            transition.update(max(0, -translation.y / view.bounds.height))
                        }
                    }
                }
            }
        case .ended, .cancelled, .failed:
            if dispatchingTo == nil && beginPoint != nil,
                let direction = interactiveDirection,
                let transition = interactionTransition {
                
                let translation = gesture.translation(in: view)
                let velocity = gesture.velocity(in: view)
                switch direction {
                case .rightFromLeft:
                    if translation.x > view.bounds.width / 4 && velocity.x > 0
                        || velocity.x > view.bounds.width {
                        transition.finish()
                    } else {
                        transition.cancel()
                    }
                case .downFromTop:
                    if translation.y > view.bounds.height / 4 && velocity.y > 0
                        || velocity.y > view.bounds.height {
                        transition.finish()
                    } else {
                        transition.cancel()
                    }
                case .upFromBottom:
                    if translation.y < -view.bounds.height / 4 && velocity.y < 0
                        || velocity.y < -view.bounds.height {
                        transition.finish()
                    } else {
                        transition.cancel()
                    }
                }
            } else {
                interactionTransition?.cancel()
            }
            beginPoint = nil
            interactiveDirection = nil
            interactionTransition = nil
            dispatchingTo = nil
        default:
            break
        }
    }
    
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let view = sourceView {
            let animator = PopUpAnimator(sourceRect: view.convert(view.bounds, to: self.view), sourceView: view)
            sourceView = nil
            return animator
        } else {
            return PopUpAnimator(sourceRect: sourceRect)
        }
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeOutAnimator(direction: interactiveDirection ?? .downFromTop)
    }
    
    internal func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionTransition
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1,
            let scrollView = otherGestureRecognizer.view as? UIScrollView {
            
            scrollView.bounces = false
            return otherGestureRecognizer.state == .failed
        }
        return false
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    internal func updateDispatch(gesture: UIGestureRecognizer, toView view: UIView, inDirection direction: SwipeDirection) {
        
        if let scrollView = view as? UIScrollView {
            let inset = scrollView.contentInset
            let offset = scrollView.contentOffset
            let height = scrollView.frame.height
            let sheight = scrollView.contentSize.height
            
            if direction == .downFromTop && offset.y > -inset.top {
                dispatchingTo = scrollView
            }
            
            if direction == .rightFromLeft && offset.x > -inset.left {
                dispatchingTo = scrollView
            }
            
            if direction == .upFromBottom && offset.y + height < sheight + inset.bottom {
                dispatchingTo = scrollView
            }
        }
        
        let point = gesture.location(in: view)
        
        for subview in view.subviews {
            if subview.frame.contains(point) {
                updateDispatch(gesture: gesture, toView: subview, inDirection: direction)
            }
        }
    }
}
