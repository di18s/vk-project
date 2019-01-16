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
    private let like = Like()
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
    override func prepareForReuse() {
        super.prepareForReuse()
        shakeLike.invalidate()
        setNeedsLayout()
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
            self.isLike = true
        case 0:
            count_like_photo.text = String(photo.countLike)
            
            if count_like_photo.text == String(0){
                self.count_like_photo.isHidden = true
            }else if count_like_photo.text != String(0){
                self.count_like_photo.isHidden = false
            }
            
            self.like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
            
            self.shakeLike = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(shakeAnimForPhoto), userInfo: nil, repeats: true)
            
            self.isLike = false
        default:
            break
        }
        
    }
}


//MARK: - вся анимация с лайками
extension AllPhotoCollectionViewCell{
    
    private func animateLike() {
        self.like.animateLike(buttonLike: self.like_heart_forPhoto, labelLike: self.count_like_photo)
    }
    
    private func stavLike(){
        like_heart_forPhoto.setImage(UIImage(named: "20"), for: .normal)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(tapForPhoto))
        like_heart_forPhoto.addGestureRecognizer(reconizer)
    }
    @objc func tapForPhoto(){
        self.like.tapLikeForPhoto(isLike: &self.isLike, labelLike: self.count_like_photo, buttonLike: self.like_heart_forPhoto, timer: &self.shakeLike, timeInterval: 5.0, target: self, selector: #selector(shakeAnimForPhoto), ownerId: self.owner_id, itemId: self.item_id, type: "photo")
    }
    //MARK:- Animation spring like
    @objc func shakeAnimForPhoto () {
        self.like.shakeLike(button: self.like_heart_forPhoto)
    }

}
