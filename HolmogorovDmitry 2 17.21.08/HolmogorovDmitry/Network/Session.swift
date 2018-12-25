import Foundation

class Session {
    
    public static let instance = Session()
    
    var userId = 0
    var token = ""
    var userAddGroup: [Group] = []
    
    var toAnyObject: [String: Any] {
        return [
            "userId": userId,
            "userAddGroup": userAddGroup.map{$0.toAnyObject}
        ]
    }
    
    private init () { }

}

