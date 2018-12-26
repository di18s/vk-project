import UIKit
import SwiftyJSON
import RealmSwift

@objcMembers
class MyPhoto: Object{
    
    dynamic var photo: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.photo = json["sizes"][3]["url"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "photo"
    }
}
