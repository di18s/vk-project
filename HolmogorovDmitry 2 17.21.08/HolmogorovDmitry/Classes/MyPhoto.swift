//
//  MyPhoto.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 03/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//
import UIKit
import SwiftyJSON

class MyPhoto{
    
    var photo: String = ""
    
    init(json: JSON) {
        self.photo = json["sizes"][3]["url"].stringValue
    }
    
}
