import  UIKit
import  SwiftyJSON
import  RealmSwift

@objcMembers
class PhotoFriend: Object {
    
    dynamic var photo: String = ""
    dynamic var isLlike: Int = 0
    dynamic var countLike: Int = 0
    dynamic var user_Id = 0
    dynamic var photo_Id = 0
    
    convenience init(json: JSON) {
        self.init()
        
        self.photo_Id = json["id"].intValue
        self.user_Id = json["owner_id"].intValue
        self.photo = json["sizes"][3]["url"].stringValue
        self.isLlike = json["likes"]["user_likes"].intValue
        self.countLike = json["likes"]["count"].intValue
    }
    override static func primaryKey() -> String? {
        return "photo"
    }
    
    var friend_photo = LinkingObjects(fromType: Friend.self, property: "photos")
    
    func delete() {
        do {
            let realm = try Realm(configuration: DatabaseService.configuration)
            
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
