//
//  AllPhotoCollectionViewCell.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 17/10/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  SwiftyJSON
import  Kingfisher

class AllPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo_Friend: UIImageView!
    @IBOutlet weak var count_like_photo: UILabel!
    @IBOutlet weak var like_heart_forPhoto: UIButton!
    private var numberLike: Int = 0
    private var isLike: Bool = false
    private var shakeLike: Timer!
    private let networkService = NetworkService()
    var owner_id = 0
    var item_id = 0
    
    public func configurePhotoFriendCell(with photo: PhotoFriend) {
        
        self.photo_Friend.kf.setImage(with: NetworkService.urlForPhoto(photo.photo))
        self.owner_id = photo.user_Id
        self.item_id = photo.photo_Id
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stavLike()
        
    }
    
    private func runShakeLike(repeats: Bool){
        shakeLike = Timer.scheduledTimer(timeInterval: 5.10, target: self, selector: #selector(shakeAnim), userInfo: nil, repeats: repeats)
    }
    
    
    func touchLike(_ infoForPhoto: PhotoFriend){ //это для конфигурации ячеек с фотками
        switch infoForPhoto.isLlike {
        case 1:
            count_like_photo.text = String(infoForPhoto.countLike)
            count_like_photo.textColor = UIColor.red
            self.like_heart_forPhoto.setImage(UIImage(named: "21"), for: .normal)
            animateLike()
            shakeLike?.invalidate()
            self.isLike = true
        case 0:
            count_like_photo.text = String(infoForPhoto.countLike)
            if count_like_photo.text == String(0){
                self.count_like_photo.isHidden = true
            }else if count_like_photo.text != String(0){
                self.count_like_photo.isHidden = false
            }
            self.like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
            runShakeLike(repeats: true)
            self.isLike = false
        default:
            break
        }
    }
    
    @objc func tap(){ //для рекогнайзера когда ставим или убираем лайк
        switch isLike {
        case true:
            
            if count_like_photo.text == String(0){
                self.count_like_photo.isHidden = true
            }else {
                self.count_like_photo.isHidden = false
            }
            count_like_photo.text = String(Int(count_like_photo.text!)! - 1)
            
            UIView.transition(with: like_heart_forPhoto,
                              duration: 0.45,
                              options: .transitionFlipFromTop,
                              animations: {
                                self.like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
            })
            
            count_like_photo.textColor = UIColor.black
            runShakeLike(repeats: true)
            isLike = false
            self.networkService.dismissLikeForPhotoAlamofire(ownerId: self.owner_id, itemId: self.item_id, type: "photo")
        case false:
            like_heart_forPhoto.setImage(UIImage(named: "21"), for: .normal)
            count_like_photo.text = String(Int(count_like_photo.text!)! + 1)
            self.count_like_photo.isHidden = false
            count_like_photo.textColor = UIColor.red
            animateLike() //прилетает сердечко и цыфра
            shakeLike.invalidate()
            isLike = true
            self.networkService.addLikeForPhotoAlamofire(ownerId: owner_id, itemId: item_id, type: "photo")
        }
    }
    
    private func stavLike(){ //это во ViewDidLoad
        like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        like_heart_forPhoto.addGestureRecognizer(reconizer)
    }
   
    //MARK:- Animation spring like
    @objc func shakeAnim () { //работает когда лайка нету (скачет сердечко)
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPoint(x:self.like_heart_forPhoto.frame.midX ,y: self.like_heart_forPhoto.frame.midY - 5)
        let from_value:NSValue = NSValue(cgPoint: from_point)
        
        let to_point:CGPoint = CGPoint(x:self.like_heart_forPhoto.frame.midX ,y: self.like_heart_forPhoto.frame.midY + 5)
        let to_value:NSValue = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        self.like_heart_forPhoto.layer.add(shake, forKey: "position")
    }
    
    //MARK:- Animation of like
    private func animateLike() { //срабатывает когда ставим лайк
        
        like_heart_forPhoto.transform = CGAffineTransform(translationX: 0, y: -bounds.height / 4)
        count_like_photo.transform = CGAffineTransform(translationX: 50, y: -bounds.height / 10)
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.like_heart_forPhoto.transform = .identity
                        self.count_like_photo.transform = .identity
        })
    }
    
    //MARK:- Animation photo
    @objc func springAnim(){ // это вроде не работает уже и можно удалить
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.95
        animation.toValue = 1
        animation.stiffness = 100
        animation.mass = 2
        animation.duration = 3
        //animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        photo_Friend.layer.add(animation, forKey: nil)
    }
}
