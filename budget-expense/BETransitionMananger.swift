//
//  BETransitionMananger.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/12/2016.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit

enum TransitionDirection {
    case up, down
}

class BETransitioningPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let direction: TransitionDirection

    init(direction: TransitionDirection) {
        self.direction = direction
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return BEConstants.Values.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView

        let fromView = fromVC.view

        var yDistance: CGFloat = 0.0
        if self.direction == .down {
            yDistance = -(toView.frame.height)
        } else {
            yDistance = toView.frame.height
        }

        toView.transform = CGAffineTransform(translationX: 0, y: yDistance)
        containerView.addSubview(toView)

        let finalFrameForToViewController = transitionContext.finalFrame(for: toVC)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .calculationModeCubic, animations: {
            // Inser here the animations

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5, animations: { 
                fromView?.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 4/5, animations: {
                toView.frame = finalFrameForToViewController
            })

        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }

}

class BETransitioningDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return BEConstants.Values.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView

        let fromView = fromVC.view!

        containerView.insertSubview(toView, at: 0)

        toView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .calculationModeCubicPaced, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5, animations: {
                fromView.transform = CGAffineTransform(translationX: 0.0, y: -fromView.frame.height)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 4/5, animations: {
                toView.transform = CGAffineTransform.identity
            })

        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }

}
