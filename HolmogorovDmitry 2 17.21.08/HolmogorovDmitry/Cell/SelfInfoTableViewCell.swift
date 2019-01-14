import UIKit

class SelfInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imageForCell: UIImageView!
    
    @IBOutlet weak var nameForCell: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
