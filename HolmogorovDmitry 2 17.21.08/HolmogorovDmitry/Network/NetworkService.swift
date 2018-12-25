//
//  NetworkServise.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 06/11/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import  Alamofire
import  SwiftyJSON

class NetworkService {
    
    static func urlForPhoto(_ photo: String) -> URL? {
        return URL(string: photo)
    }
    
    //MARK:- Функция загрузки друзей пользователя
    func loadUserFriendsAlamofire(completion: (([Friend]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "order": "name",
            //                "order": "hints",
            //"count": "10",
            "fields": "photo_100",
            "v": "5.87",
            "user_id": Session.instance.userId
        ]
        
            Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()){ (response) in
                
                switch response.result {
                case .failure(let error):
                    completion?(nil, error)
                    
                case .success(let value):
                    //print(value)
                    let json = JSON(value)
                    
                    let friends = json["response"]["items"].arrayValue.map { Friend(json: $0) }
                    completion?(friends, nil)
                }
            }
        
        
    }
    
    //MARK:- Функция загрузки фото друга
    
    func loadUserPhotoAlamofire(ownerId: Int, completion: (([PhotoFriend]?, Error?) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "owner_id": ownerId,
            "extended": "1",
            "v": "5.87"
        ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                let json = JSON(value)
                
                let photoFriend = json["response"]["items"].arrayValue.map { PhotoFriend(json: $0) }
                
                completion?(photoFriend, nil)
            }
        }
    }
    
    //MARK:- Функция загрузки своих фото
    
    func loadMyPhotoAlamofire(completion: (([MyPhoto]?, Error?) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "owner_id": Session.instance.userId,
            "extended": "1",
            "v": "5.87"
        ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                let json = JSON(value)
                //print(value)
                let photo = json["response"]["items"].arrayValue.map { MyPhoto(json: $0) }
                
                completion?(photo, nil)
            }
        }
    }
    
    //MARK:- Функция загрузки групп пользователя
    
    func loadUserGroupsAlamofire(completion: (([Group]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "fields": "type",
            "v": "5.52",
            "extended": 1,
            "user_id": Session.instance.userId
        ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                //print(value)
                let json = JSON(value)
                
                let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                
                completion?(groups, nil)
            }
        }
    }
    
    //MARK:- Функция поиска групп по ключевому слову
    
    func loadGroupSearchAlamofire(keyword: String?, completion: (([Group]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "q": keyword ?? "a",
            "v": "5.52"
        ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                //print(value)
                let json = JSON(value)
                
                let newGroups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                
                completion?(newGroups, nil)
            }
        }
    }
    
    //MARK:- Функция вступления в группу
    
    func joinInNewGroupAlamofire(groupId: Int) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/groups.join"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "group_id": groupId,
            "v": "5.52"
        ]
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                _ = JSON(value)
  
            }
        }
    }
    
    //MARK:- Функция выхода из группы
    func leaveFromGroupAlamofire(groupId: Int) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/groups.leave"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "group_id": groupId,
            "v": "5.52"
        ]
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                _ = JSON(value)
                
            }
        }
    }
    //MARK:- Функция поиска друзей пользователя
    func loadSearchFriendUserAlamofire(keyword: String?, completion: (([Friend]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/friends.search"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "q": keyword ?? "D",
            "fields": "photo_100",
            "user_id": Session.instance.userId,
            "v": "5.87",
            ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                let json = JSON(value)
                
                let friends = json["response"]["items"].arrayValue.map { Friend(json: $0) }
                completion?(friends, nil)
            }
        }
    }

    
    //MARK:- Функция загрузки новостей
    func loadNewsAlamofire(completion: (([News]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "filters": "wall_photo, photo",
            "count": 60,
            "v": "5.87",
            ]
        
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in

            switch response.result {
            case .failure(let error):
                completion?(nil, error)

            case .success(let value):
                let json = JSON(value)

                let infoUser = json["response"]["profiles"].arrayValue.map{News(json: $0)}
                let infoGroup = json["response"]["groups"].arrayValue.map{News(json: $0)}

                var news = [News]()
                

                    for j in json["response"]["items"]{
                        news += j.1["photos"]["items"].arrayValue.map { News(json: $0) }
                    }
                
 
                    for n in news{
                        for i in infoUser{
                            if n.owner_id == i.user_idInProfile {
                                n.avatarUser = i.avatarUser
                                n.nameUser = i.nameUser
                                n.lastNameUser = i.lastNameUser
                            }
                        }
                        for g in infoGroup{
                            if n.owner_id == g.group_idInGroups {
                                n.avatarUser = g.avatarUser
                                n.nameUser = g.groupName
                                n.lastNameUser = ""
                            }
                        }
                    }
                completion?(news, nil)
            }
        }
    }
    
    //MARK:- Функция снятия лайка
    func dismissLikeForPhotoAlamofire(ownerId: Int, itemId: Int, type: String) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/likes.delete"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "type": type,
            "owner_id": ownerId,
            "item_id": itemId,
            "v": "5.92"
        ]
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                _ = JSON(value)
                
            }
        }
    }
    
    //MARK:- Функция добавить лайк
    func addLikeForPhotoAlamofire(ownerId: Int, itemId: Int, type: String) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/likes.add"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "type": type,
            "owner_id": ownerId,
            "item_id": itemId,
            "v": "5.92"
        ]
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                _ = JSON(value)
                
            }
        }
    }
    
    //MARK:- Функция получения своей информации
    
    func loadSelfInfoAlamofire(completion: (([MyInfo]?, Error?) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/users.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "user_ids": Session.instance.userId,
            "fields": "photo_100",
            "v": "5.87"
        ]
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()) { (response) in
            
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                
            case .success(let value):
                let json = JSON(value)
                //print(value)
                let info = json["response"].arrayValue.map { MyInfo(json: $0) }
                
                completion?(info, nil)
            }
        }
    }
    
}
