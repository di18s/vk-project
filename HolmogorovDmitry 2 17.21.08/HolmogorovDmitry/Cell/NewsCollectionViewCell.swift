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
    private let like = Like()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stavLikeNews()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        shakeLikeNews.invalidate()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

//MARK: - Ручной лэйаут
extension NewsCollectionViewCell{
    
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
    
}

//MARK: - Вся анимация с лайками
extension NewsCollectionViewCell{
    
    private func animateLike() {
        self.like.animateLike(buttonLike: self.buttonLike, labelLike: self.labelLike)
    }
    
    private func stavLikeNews(){
        buttonLike.setImage(UIImage(named: "20"), for: .normal)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tapForNews))
        buttonLike.addGestureRecognizer(reconizer)
    }
    @objc func tapForNews(){
        self.like.tapLike(isLike: &self.isLike, labelLike: self.labelLike, buttonLike: self.buttonLike, timer: &self.shakeLikeNews, timeInterval: 5.0, target: self, selector: #selector(shakeAnimForNews))
    }
    //MARK:- Animation spring like
    @objc func shakeAnimForNews () {
        self.like.shakeLike(button: self.buttonLike)
    }
}

//MARK: - Конфигурация ячеек
extension NewsCollectionViewCell{
   
    
    public func configureNewsCell(with news: News, dateFormatter: DateFormatter ) {
        
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
        
        switch news.isLike {
        case 1:
            labelLike.text = String(news.countLikeNews)
            labelLike.textColor = UIColor.red
            buttonLike.setImage(UIImage(named: "21"), for: .normal)
            isLike = true
        case 0:
            labelLike.text = String(news.countLikeNews)
            
            if labelLike.text == String(0){
                self.labelLike.isHidden = true
            }else if labelLike.text != String(0){
                self.labelLike.isHidden = false
            }
            
            self.shakeLikeNews = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(shakeAnimForNews), userInfo: nil, repeats: true)
            
            buttonLike.setImage(UIImage(named: "20"), for: .normal)
            isLike = false
        default:
            break
        }
        
    }
}
