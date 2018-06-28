//
//  TransitionManager.swift
//  Transition
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var coef = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(toView)
        container.addSubview(fromView)
        let duration = self.transitionDuration(using: transitionContext)
        toView.frame.origin.x = CGFloat(self.coef) * container.frame.width
        print((CGFloat(self.coef) * container.frame.width))
        print("from : " + (fromView.frame.origin.x).description)
        print("to : " + (toView.frame.origin.x).description)
        print("=========")
        
        UIView.animate(withDuration : duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {
            
            fromView.frame.origin.x = fromView.frame.origin.x - (CGFloat(self.coef) * container.frame.width)
            toView.frame.origin.x = 0
            

        }, completion: { finished in

            print("from : " + (fromView.frame.origin.x).description)
            print("to : " + (toView.frame.origin.x).description)
            transitionContext.completeTransition(true)
            
        })
    }
    

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
   
    
}
