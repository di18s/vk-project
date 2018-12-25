import Foundation
import  SwiftyJSON
import  RealmSwift

@objcMembers
class  Friend: Object {
    dynamic var name: String = ""
    dynamic var last_Name: String = ""
    dynamic var avatar: String = ""
    dynamic var userId: Int = 0
    var photos = List<PhotoFriend>()

    convenience init(json: JSON, photos: [PhotoFriend] = []) {
        self.init()
        
        self.photos.append(objectsIn: photos )
        self.name = json["first_name"].stringValue
        self.last_Name = json["last_name"].stringValue
        self.avatar = json["photo_100"].stringValue
        self.userId = json["id"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }

}
