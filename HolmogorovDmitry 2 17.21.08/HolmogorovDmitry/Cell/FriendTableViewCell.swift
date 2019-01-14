import UIKit
import  SwiftyJSON
import  Kingfisher
import  PinLayout

class FriendTableViewCell: UITableViewCell{


    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var frameAvatar: UIView!
    var user_id = 1
  
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowAvatar(view: frameAvatar)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        handMadeLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureFriendCell(with friend: Friend) {
        
        self.friendName.text = friend.name
        self.lastName.text = friend.last_Name
        self.photo.kf.setImage(with: PhotoNetwork.urlForPhoto(friend.avatar))
        self.user_id = friend.userId
        
        setNeedsLayout()
    }
    
   

}

extension FriendTableViewCell{
    
    func shadowAvatar(view: UIView){
        view.layer.shadowColor = UIColor.red.cgColor
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize.zero
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
    }
    
    func handMadeLayout(){
        self.photo.pin.vCenter().size(75).marginLeft(25)
        self.frameAvatar.pin.vCenter(to: self.photo.edge.vCenter).size(80)
        self.friendName.pin.after(of: self.photo, aligned: .center).height(20).sizeToFit(.height).marginLeft(15)
        self.lastName.pin.after(of: self.friendName, aligned: .center).height(20).sizeToFit(.height).marginLeft(3)
    }
    
}
