//
//  SlowPresent.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/13.
//

import UIKit

final class SlowPresent: NSObject {
    enum AnimationType {
        case present, dismiss
    }
    
    private let duration: Double
    private let animationType: AnimationType
    
    init(duration: Double, animationType: AnimationType) {
        self.duration = duration
        self.animationType = animationType
    }
}

extension SlowPresent: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let fromView = fromVC.view,
              let toVC = transitionContext.viewController(forKey: .to),
              let toView = toVC.view
        else {
            transitionContext.completeTransition(false)
            return
        }

        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toView)
            presentAnimation(with: transitionContext, toView: toView)
        case .dismiss:
            dismissAnimation(with: transitionContext, fromView: fromView)
        }
    }
    
    private func presentAnimation(
        with transitionContext: UIViewControllerContextTransitioning,
        toView: UIView
    ) {
        let animationDuration = transitionDuration(using: transitionContext)
        toView.alpha = 0
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                toView.alpha = 1
            },
            completion: {
                transitionContext.completeTransition($0)
            }
        )
    }
    
    private func dismissAnimation(
        with transitionContext: UIViewControllerContextTransitioning,
        fromView: UIView
    ) {
        let animationDuration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                fromView.alpha = 0
            },
            completion: {
                transitionContext.completeTransition($0)
            }
        )
    }
}
