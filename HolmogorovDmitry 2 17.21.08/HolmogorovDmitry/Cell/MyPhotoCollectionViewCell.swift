import UIKit
import  Kingfisher
import  PinLayout


class MyPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myPhotoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func configurePhotoCell(with photo: MyPhoto) {
        
        self.myPhotoImg.kf.setImage(with: PhotoNetwork.urlForPhoto(photo.photo))
        
        setNeedsLayout()
    }
    
    private func handMadeLayout(){
        self.myPhotoImg.pin.size(100).topLeft().marginLeft(1)
    }
}


