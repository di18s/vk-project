//
//  NewGroupTableViewCell.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
