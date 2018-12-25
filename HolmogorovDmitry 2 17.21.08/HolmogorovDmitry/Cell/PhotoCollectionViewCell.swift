//
//  PhotoCollectionViewCell.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsPhoto: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var countLike: UILabel!
    @IBOutlet weak var likeHeartView: UIView!
    @IBOutlet weak var backImg: UIImageView!
    private var numberLike: Int = 0
    private var isLike: Bool = false
    private var shakeLike: Timer!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        stavLike()
//        let animPhotoFriend = UITapGestureRecognizer(target: self, action: #selector(springAnim))
//        self.friendsPhoto.addGestureRecognizer(animPhotoFriend)
//        runShakeLike(repeats: true)
        
    }

    private func runShakeLike(repeats: Bool){
        shakeLike = Timer.scheduledTimer(timeInterval: 5.10, target: self, selector: #selector(shakeAnim), userInfo: nil, repeats: repeats)
    }
    
    //MARK:- Animation and func of like
    private func animateLike() {
        
        likeButton.transform = CGAffineTransform(translationX: 0, y: -bounds.height / 4)
        countLike.transform = CGAffineTransform(translationX: 50, y: -bounds.height / 10)
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.likeButton.transform = .identity
                        self.countLike.transform = .identity
        })
    }
  
    @objc func tap(){
        switch isLike {
        case true:
            numberLike -= 1
            countLike.text = ""
            isLike = false
            UIView.transition(with: likeButton,
                              duration: 0.45,
                              options: .transitionFlipFromTop,
                              animations: {
                              self.likeButton.setImage(UIImage(named: "20"), for: .normal)
            })
            runShakeLike(repeats: true)
        case false:
            likeButton.setImage(UIImage(named: "21"), for: .normal)
            numberLike += 1
            countLike.text = String(numberLike)
            countLike.textColor = UIColor.red
            isLike = true
            animateLike()
            shakeLike.invalidate()
        }
    }
    private func stavLike(){
        likeButton.setImage(UIImage(named: "20"), for: .normal)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        likeHeartView.addGestureRecognizer(reconizer)
    }
    //MARK:- Animation photo
    @objc func springAnim(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.95
        animation.toValue = 1
        animation.stiffness = 100
        animation.mass = 2
        animation.duration = 3
        //animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = kCAFillModeBackwards
        
        friendsPhoto.layer.add(animation, forKey: nil)
    }
    //MARK:- Animation spring like
    @objc func shakeAnim () {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPoint(x:self.likeButton.frame.midX ,y: self.likeButton.frame.midY - 5)
        let from_value:NSValue = NSValue(cgPoint: from_point)
        
        let to_point:CGPoint = CGPoint(x:self.likeButton.frame.midX ,y: self.likeButton.frame.midY + 5)
        let to_value:NSValue = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        self.likeButton.layer.add(shake, forKey: "position")
    }
    
}

