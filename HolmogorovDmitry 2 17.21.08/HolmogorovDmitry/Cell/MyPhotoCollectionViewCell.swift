//
//  CollectionViewCell.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 03/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  Kingfisher



class MyPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myPhotoImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    public func configurePhotoCell(with photo: MyPhoto) {
        
        self.myPhotoImg.kf.setImage(with: NetworkService.urlForPhoto(photo.photo))
        
    }
}

