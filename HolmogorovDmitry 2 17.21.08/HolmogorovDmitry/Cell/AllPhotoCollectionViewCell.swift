import UIKit
import  SwiftyJSON
import  Kingfisher
import PinLayout

class AllPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var whiteBackBottomView: UIView!
    @IBOutlet weak var photo_Friend: UIImageView!
    @IBOutlet weak var count_like_photo: UILabel!
    @IBOutlet weak var like_heart_forPhoto: UIButton!
    
    private var numberLike: Int = 0
    private var isLike: Bool = false
    private var shakeLike: Timer!
    private let networkService = PhotoNetwork()
    private var likeNetworkService = LikeNetwork()
    var owner_id = 0
    var item_id = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stavLike()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        handMadeLayout()
    }
    
    private func handMadeLayout(){
        self.whiteBackBottomView.pin.bottom().width(100%).height(40)
        self.photo_Friend.pin.top().bottom(40.5).width(100%)
        self.like_heart_forPhoto.pin.vCenter(to: self.whiteBackBottomView.edge.vCenter).marginLeft(10).size(30)
        self.count_like_photo.pin.after(of: self.like_heart_forPhoto, aligned: .top).height(30).marginLeft(5)
    }

}

//MARK: - Методы конфигурации ячеек
extension AllPhotoCollectionViewCell{
    
    public func configurePhotoFriendCell(with photo: PhotoFriend) {
        
        self.photo_Friend.kf.setImage(with: PhotoNetwork.urlForPhoto(photo.photo))
        self.owner_id = photo.user_Id
        self.item_id = photo.photo_Id
        
        switch photo.isLlike { //получаем из сети данные стоит или нет наш лайк
        case 1:
            count_like_photo.text = String(photo.countLike)
            count_like_photo.textColor = UIColor.red
            self.like_heart_forPhoto.setImage(UIImage(named: "21"), for: .normal)
            shakeLike?.invalidate() //если наш лайк стоит то репит откл(по идее можно удалить вообще)
            self.isLike = true
        case 0:
            count_like_photo.text = String(photo.countLike)
            if count_like_photo.text == String(0){
                self.count_like_photo.isHidden = true
            }else if count_like_photo.text != String(0){
                self.count_like_photo.isHidden = false
            }
            self.like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
            runShakeLike(repeats: true) //если наш лайк не стоит то репит вкл
            self.isLike = false //возможно с передачей этого праметра проблемы и у меня скачет чаще чем надо
        default:
            break
        }
        
        setNeedsLayout()
    }
}


//MARK: - вся анимация с лайками
extension AllPhotoCollectionViewCell{
    
    private func runShakeLike(repeats: Bool){
        shakeLike = Timer.scheduledTimer(timeInterval: 5.10, target: self, selector: #selector(shakeAnim), userInfo: nil, repeats: repeats)
    }
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
    
    
    //MARK: -  рекогнайзер для лайков
    private func stavLike(){ //это во ViewDidLoad
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        like_heart_forPhoto.addGestureRecognizer(reconizer)
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
            runShakeLike(repeats: true) //убрали лайк репит включился
            isLike = false
            self.likeNetworkService.dismissLikeForPhotoAlamofire(ownerId: self.owner_id, itemId: self.item_id, type: "photo")
        case false:
            like_heart_forPhoto.setImage(UIImage(named: "21"), for: .normal)
            count_like_photo.text = String(Int(count_like_photo.text!)! + 1)
            self.count_like_photo.isHidden = false
            count_like_photo.textColor = UIColor.red
            animateLike() //прилетает сердечко и цыфра
            shakeLike.invalidate() //поставили лайк репит отключается
            isLike = true 
            self.likeNetworkService.addLikeForPhotoAlamofire(ownerId: owner_id, itemId: item_id, type: "photo")
        }
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

}
