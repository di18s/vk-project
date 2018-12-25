import  UIKit
import  SwiftyJSON

class MyInfo {
    var name: String = ""
    var lastName: String = ""
    var myAvatar: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.name = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.myAvatar = json["photo_100"].stringValue
    }
   
}
