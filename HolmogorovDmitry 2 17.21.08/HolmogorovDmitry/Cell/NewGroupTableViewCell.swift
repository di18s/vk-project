import UIKit
import  SwiftyJSON
import  Kingfisher

class NewGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageNewGroup: UIImageView!
    @IBOutlet weak var labelNewGroup: UILabel!
    @IBOutlet weak var infoLabelNewGroup: UILabel!
    
    public func configureNewsGroupCell(with group: Group) {
        
        self.labelNewGroup.text = group.nameGroup
        self.infoLabelNewGroup.text = group.infoLabel
        self.imageNewGroup.kf.setImage(with: PhotoNetwork.urlForPhoto(group.avatarGroup))
        
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
        self.imageNewGroup.pin.size(50).vCenter().left(15)
        self.labelNewGroup.pin.after(of: self.imageNewGroup, aligned: .center).height(18).marginLeft(15).sizeToFit(.height)
        self.infoLabelNewGroup.pin.below(of: self.labelNewGroup, aligned: .left).height(10).sizeToFit(.height).marginTop(1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
