import Foundation
import RealmSwift

class DatabaseService {
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    @discardableResult
    static func saveToRealm<Element: Object>(items: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) -> Realm? {
        
        do {
            let realm = try Realm(configuration: config)
            
            print(realm.configuration.fileURL ?? "")
            
            try realm.write {
                realm.add(items, update: update)
            }
            
            return realm
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
//    @discardableResult
//    static func deleteFromRealm<Element: Object>(items: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) -> Realm? {
//        
//        do {
//            let realm = try Realm(configuration: config)
//            
//            print(realm.configuration.fileURL ?? "")
//            
//            try realm.write {
//                realm.delete(items)
//            }
//            
//            return realm
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return nil
//    }
    
    @discardableResult
    static func loadFromRealm<T: Object>(_ type: T.Type, in realm: Realm? = try? Realm(configuration: DatabaseService.configuration)) -> Results<T>? {
        return realm?.objects(type)
    }
    
}
