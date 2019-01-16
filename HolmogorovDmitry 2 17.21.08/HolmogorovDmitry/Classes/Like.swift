//
//  Like.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 16/01/2019.
//  Copyright © 2019 Dmitry. All rights reserved.
//

import UIKit

class Like {
   private let likeNetworkService = LikeNetwork()
    
    func animateLike(buttonLike: UIButton, labelLike: UILabel) {
        buttonLike.transform = CGAffineTransform(translationX: 0, y: 50)
        labelLike.transform = CGAffineTransform(translationX: 50, y: 50)
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        buttonLike.transform = .identity
                        labelLike.transform = .identity
        })
    }
    
    func tapLike(isLike: inout Bool, labelLike: UILabel, buttonLike: UIButton, timer: inout Timer, timeInterval: TimeInterval, target: Any, selector: Selector){
        switch isLike {
        case true:
            
            if labelLike.text == String(0){
                labelLike.isHidden = true
            }else if labelLike.text != String(0){
                labelLike.isHidden = false
            }
            labelLike.text = String(Int(labelLike.text!)! - 1)
            UIView.transition(with: buttonLike,
                              duration: 0.45,
                              options: .transitionFlipFromTop,
                              animations: {
                                buttonLike.setImage(UIImage(named: "20"), for: .normal)
                                
            })
            
            labelLike.textColor = UIColor.black
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: nil, repeats: true)
            isLike = false
        case false:
            buttonLike.setImage(UIImage(named: "21"), for: .normal)
            labelLike.text = String(Int(labelLike.text!)! + 1)
            labelLike.isHidden = false
            labelLike.textColor = UIColor.red
            animateLike(buttonLike: buttonLike, labelLike: labelLike)
            timer.invalidate()
            isLike = true
        }
    }
    
    func tapLikeForPhoto(isLike: inout Bool, labelLike: UILabel, buttonLike: UIButton, timer: inout Timer, timeInterval: TimeInterval, target: Any, selector: Selector, ownerId: Int, itemId: Int, type: String){
        switch isLike {
        case true:
            
            if labelLike.text == String(0){
                labelLike.isHidden = true
            }else if labelLike.text != String(0){
                labelLike.isHidden = false
            }
            labelLike.text = String(Int(labelLike.text!)! - 1)
            UIView.transition(with: buttonLike,
                              duration: 0.45,
                              options: .transitionFlipFromTop,
                              animations: {
                                buttonLike.setImage(UIImage(named: "20"), for: .normal)
                                
            })
            
            labelLike.textColor = UIColor.black
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: nil, repeats: true)
            isLike = false
            self.likeNetworkService.dismissLikeForPhotoAlamofire(ownerId: ownerId, itemId: itemId, type: type)
        case false:
            buttonLike.setImage(UIImage(named: "21"), for: .normal)
            labelLike.text = String(Int(labelLike.text!)! + 1)
            labelLike.isHidden = false
            labelLike.textColor = UIColor.red
            animateLike(buttonLike: buttonLike, labelLike: labelLike)
            timer.invalidate()
            isLike = true
            self.likeNetworkService.addLikeForPhotoAlamofire(ownerId: ownerId, itemId: itemId, type: type)
        }
    }
    
    func shakeLike(button: UIButton){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPoint(x:button.frame.midX ,y: button.frame.midY - 5)
        let from_value:NSValue = NSValue(cgPoint: from_point)
        
        let to_point:CGPoint = CGPoint(x:button.frame.midX ,y: button.frame.midY + 5)
        let to_value:NSValue = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        button.layer.add(shake, forKey: "position")
    }
}
