import UIKit
import  SwiftyJSON
import  Kingfisher
import  PinLayout

class MyGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var labelGroup: UILabel!
    @IBOutlet weak var infoLabelMyGroup: UILabel!
    
    public func configureGroupCell(with group: Group) {
        
        self.labelGroup.text = group.nameGroup
        self.infoLabelMyGroup.text = group.infoLabel
        self.imageGroup.kf.setImage(with: PhotoNetwork.urlForPhoto(group.avatarGroup))
        
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        handMadeLayout()
    }
    
    private func handMadeLayout(){
        self.imageGroup.pin.size(50).vCenter().left(15)
        self.labelGroup.pin.after(of: self.imageGroup, aligned: .center).height(18).marginLeft(15).sizeToFit(.height)
        self.infoLabelMyGroup.pin.below(of: self.labelGroup, aligned: .left).height(10).sizeToFit(.height).marginTop(1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
