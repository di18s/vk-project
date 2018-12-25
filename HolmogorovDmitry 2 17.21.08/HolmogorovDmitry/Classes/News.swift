import UIKit
import  SwiftyJSON

class News {
    var photoNews: String = ""
    var selfComment: String = ""
    var countLikeNews: Int = 11
    var isLike: Int = 0
    var countComment: Int = 11
    var isComment: Int = 0
    var countViewNews: Int = 11
    var repostCount: Int = 11
    var isRepost: Int = 0
    var date = 0.0
    var nameUser: String = ""
    var lastNameUser: String = ""
    var avatarUser = ""
    var owner_id = 0
    var user_idInProfile = 0
    var group_idInGroups = 0
    var groupName = ""
    
  
    init(json: JSON) {
        
        self.date = json["date"].doubleValue
        self.photoNews = json["sizes"][3]["url"].stringValue
        
        self.isLike = json["likes"]["user_likes"].intValue
        self.countLikeNews = json["likes"]["count"].intValue
        
        self.selfComment = json["text"].stringValue
        self.countComment = json["comments"]["count"].intValue
        
        //self.countViewNews = json[][].intValue
        self.repostCount = json["reposts"]["count"].intValue
        self.owner_id = json["owner_id"].intValue // для групп получаем с минусом

        self.nameUser = json["first_name"].stringValue
        self.lastNameUser = json["last_name"].stringValue
        self.avatarUser = json["photo_50"].stringValue
        self.user_idInProfile = json["id"].intValue
        
        self.group_idInGroups = json["id"].intValue * -1 //тут получаем без минуса но для сравнения нам нужен минус
        self.groupName = json["name"].stringValue
    }
    
}

