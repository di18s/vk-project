//
//  NewsCollectionViewCell.swift
//  contraints
//
//  Created by Дмитрий on 02/10/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  PinLayout

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var whiteBackBottom: UIView!
    @IBOutlet weak var whiteBack: UIView!
    @IBOutlet weak var selfCommentNews: UILabel!
    @IBOutlet weak var countReposts: UILabel!
    @IBOutlet weak var countComments: UILabel!
    @IBOutlet weak var timeOfNews: UILabel!
    @IBOutlet weak var userLastNameForNEws: UILabel!
    @IBOutlet weak var userNameForNews: UILabel!
    @IBOutlet weak var userAvatarForNews: UIImageView!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var countView: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var repostNews: UIButton!
    @IBOutlet weak var commentNews: UIButton!
    @IBOutlet weak var labelLike: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    private var numberLike: Int = 0
    private var isLike: Bool = false
    private var shakeLikeNews: Timer!
    private let networkService = NewsNetwork()

    
    //MARK: - configure cell
    private var dateFormatter: DateFormatter {
        let dt = DateFormatter()
        dt.dateFormat = "EEEE, HH:mm, yyyy-MM-dd"
        return dt
    }
    
    public func configureNewsCell(with news: News) {
        
        self.selfCommentNews.text = news.selfComment
        
        self.countReposts.text = String(news.repostCount)

        self.countComments.text = String(news.countComment)
        
        let date = Date(timeIntervalSince1970: news.date)
        self.timeOfNews.text = dateFormatter.string(from: date)
        
        self.countView.text = String(news.countViewNews)
        
        
        self.imageNews.kf.setImage(with: PhotoNetwork.urlForPhoto(news.photoNews))
     
        self.userAvatarForNews.kf.setImage(with: PhotoNetwork.urlForPhoto(news.avatarUser))
        self.userNameForNews.text = news.nameUser
        self.userLastNameForNEws.text = news.lastNameUser
        
        setNeedsLayout()

    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        stavLikeNews()

    }
    
    //MARK: - тут ручной лэйаут
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.whiteBackBottom.pin.width(100%).bottom().height(30)
        self.imageNews.pin.verticallyBetween(self.whiteBackBottom, and: self .selfCommentNews).width(100%)
        self .whiteBack.pin.width(100%).top().height(91)
        
        self.buttonLike.pin.vCenter(to: self.whiteBackBottom.edge.vCenter).left().marginLeft(5).size(20)
        self.labelLike.pin.after(of: self.buttonLike, aligned: .top).marginLeft(5).height(20).width(45)
        
        self.commentNews.pin.after(of: self.labelLike, aligned: .top).marginLeft(25).size(20)
        self.countComments.pin.after(of: self.commentNews, aligned: .top).marginLeft(5).height(20).width(45)
        
        self.repostNews.pin.after(of: self.countComments, aligned: .top).marginLeft(25).size(20)
        self.countReposts.pin.after(of: self.repostNews, aligned: .top).marginLeft(5).height(20).width(45)
        
        self.countView.pin.vCenter(to: self.whiteBackBottom.edge.vCenter).right().marginRight(5).height(20).sizeToFit()
        self.iconView.pin.before(of: self.countView, aligned: .top).marginRight(5).size(20)
        
        self.selfCommentNews.pin.above(of: self.imageNews, aligned: .left).height(21).marginLeft(5).width(100%)
        self.userAvatarForNews.pin.above(of: self.selfCommentNews, aligned: .left).size(50).marginBottom(5)
        
        self.userNameForNews.pin.after(of: self.userAvatarForNews, aligned: .center).marginLeft(5).height(20).sizeToFit(.height)
        self.userLastNameForNEws.pin.after(of: self.userNameForNews, aligned: .top).marginLeft(5).height(20).sizeToFit(.height)
        self.timeOfNews.pin.below(of: self.userNameForNews, aligned: .left).marginTop(1).height(12).sizeToFit(.height)
    }
    
    private func runShakeLikeNews(repeats: Bool){
        shakeLikeNews = Timer.scheduledTimer(timeInterval: 5.10, target: self, selector: #selector(shakeAnimForNews), userInfo: nil, repeats: repeats)
    }
    
    //MARK:- Animation and func of like
    private func animateLike() {
        
        buttonLike.transform = CGAffineTransform(translationX: 0, y: -bounds.height / 4)
        labelLike.transform = CGAffineTransform(translationX: 50, y: -bounds.height / 10)
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.buttonLike.transform = .identity
                        self.labelLike.transform = .identity
        })
    }
    
    func touchLikeForNews(_ infoForNews: News){
        switch infoForNews.isLike {
        case 1:
            labelLike.text = String(infoForNews.countLikeNews)
            labelLike.textColor = UIColor.red
            buttonLike.setImage(UIImage(named: "21"), for: .normal)
            shakeLikeNews?.invalidate()
            isLike = true
        case 0:
            labelLike.text = String(infoForNews.countLikeNews)
            if labelLike.text == String(0){
                self.labelLike.isHidden = true
            }else if labelLike.text != String(0){
               self.labelLike.isHidden = false
            }
            runShakeLikeNews(repeats: true)
            buttonLike.setImage(UIImage(named: "20"), for: .normal)
            isLike = false
        default:
            break
        }
    }
    
    @objc func tapForNews(){
        switch isLike {
        case true:
            
            if labelLike.text == String(0){
                self.labelLike.isHidden = true
            }else if labelLike.text != String(0){
                self.labelLike.isHidden = false
            }
            self.labelLike.text = String(Int(self.labelLike.text!)! - 1)
            UIView.transition(with: buttonLike,
                              duration: 0.45,
                              options: .transitionFlipFromTop,
                              animations: {
                                self.buttonLike.setImage(UIImage(named: "20"), for: .normal)
                                
            })
            
            labelLike.textColor = UIColor.black
            runShakeLikeNews(repeats: true)
            isLike = false
        case false:
            buttonLike.setImage(UIImage(named: "21"), for: .normal)
            labelLike.text = String(Int(labelLike.text!)! + 1)
            self.labelLike.isHidden = false
            labelLike.textColor = UIColor.red
            animateLike()
            shakeLikeNews.invalidate()
            isLike = true
        }
    }
    
    private func stavLikeNews(){
        buttonLike.setImage(UIImage(named: "20"), for: .normal)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tapForNews))
        buttonLike.addGestureRecognizer(reconizer)
    }

    //MARK:- Animation spring like
    @objc func shakeAnimForNews () {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPoint(x:self.buttonLike.frame.midX ,y: self.buttonLike.frame.midY - 5)
        let from_value:NSValue = NSValue(cgPoint: from_point)
        
        let to_point:CGPoint = CGPoint(x:self.buttonLike.frame.midX ,y: self.buttonLike.frame.midY + 5)
        let to_value:NSValue = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        self.buttonLike.layer.add(shake, forKey: "position")
    }
}
