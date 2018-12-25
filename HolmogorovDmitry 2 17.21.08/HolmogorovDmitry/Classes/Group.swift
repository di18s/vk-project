//
//  Groups.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  SwiftyJSON
import RealmSwift

@objcMembers
class Group: Object {
    
    dynamic var nameGroup: String = ""
    dynamic var avatarGroup: String = ""
    var infoLabel: String = ""
    dynamic var idGroup: Int = 0
    
    var toAnyObject: Any {
        return [
            "nameGroup": nameGroup
        ]
    }
    
    
    convenience init(json: JSON) {
        self.init()
        self.idGroup = json["id"].intValue
        self.nameGroup = json["name"].stringValue
        self.avatarGroup = json["photo_50"].stringValue
        self.infoLabel = json["type"].stringValue
    }
    override static func primaryKey() -> String? {
        return "idGroup"
    }
  
}

