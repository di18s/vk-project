//
//  File.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 16/11/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import SwiftyJSON

class LocalNews {
    var nameUser: String = ""
    var lastNameUser: String = ""
    var avatarUser = ""
    var user_idInProfile = 0
    
    init(json: JSON){
        self.nameUser = json["first_name"].stringValue
        self.lastNameUser = json["last_name"].stringValue
        self.avatarUser = json["photo_50"].stringValue
        self.user_idInProfile = json["id"].intValue
    }
}
