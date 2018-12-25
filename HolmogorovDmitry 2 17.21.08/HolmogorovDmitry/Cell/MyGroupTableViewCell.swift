//
//  GroupTableViewCell.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  SwiftyJSON
import  Kingfisher

class MyGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var labelGroup: UILabel!
    @IBOutlet weak var infoLabelMyGroup: UILabel!
    
    public func configureGroupCell(with group: Group) {
        
        self.labelGroup.text = group.nameGroup
        self.infoLabelMyGroup.text = group.infoLabel
        self.imageGroup.kf.setImage(with: NetworkService.urlForPhoto(group.avatarGroup))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
