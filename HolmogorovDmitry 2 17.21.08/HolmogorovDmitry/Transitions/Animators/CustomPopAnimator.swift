
import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        
        let translation = CGAffineTransform(translationX: -600, y: 0)
        let angle = CGAffineTransform(rotationAngle: CGFloat.pi/3)
        destination.view.transform = translation.concatenating(angle)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        //Эта анимация мне больше нравится
//                                                        source.view.layer.cornerRadius = 40
//                                                        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                                                        let rotating = CGAffineTransform(rotationAngle: 5.2360)
//
//                                                        source.view.transform = scale.concatenating(rotating)
                                                        //source.view.alpha = 0.01
                                                        
                                                        //а эта анимация по заданию
                                                        let translationPop = CGAffineTransform(translationX: -source.view.frame.width, y: source.view.frame.height)
                                                        let anglePop = CGAffineTransform(rotationAngle: -CGFloat.pi)
                                                        source.view.transform = translationPop.concatenating(anglePop)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.3,
                                                       relativeDuration: 0.6,
                                                       animations: {
                                                        source.view.frame.origin.x += 600
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.55,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
