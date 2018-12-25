import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        let firstTranslation = CGAffineTransform(translationX: -source.view.frame.width*2, y: source.view.frame.height)
        let firstAngle = CGAffineTransform(rotationAngle: CGFloat.pi)
        destination.view.transform = firstTranslation.concatenating(firstAngle)
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {

                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 1,
                                   animations: {
                                    source.view.frame.origin.x -= 500
                                    source.view.frame.origin.y -= source.view.frame.height
                                    let translationPush = CGAffineTransform(rotationAngle: -CGFloat.pi/3*4)
                                    let scalePush = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                    source.view.transform = translationPush.concatenating(scalePush)
                })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
