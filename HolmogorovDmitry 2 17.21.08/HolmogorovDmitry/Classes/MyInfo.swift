import  UIKit
import  SwiftyJSON
import RealmSwift

@objcMembers
class MyInfo: Object {
    dynamic var name: String = ""
    dynamic var lastName: String = ""
    dynamic var myAvatar: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.name = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.myAvatar = json["photo_100"].stringValue
    }
    override static func primaryKey() -> String? {
        return "lastName"
    }
}
