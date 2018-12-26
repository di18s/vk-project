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

class FriendsNetwork {
  
    //MARK:- Функция загрузки друзей пользователя
    func loadUserFriendsAlamofire(completion: (([Friend]?, Error?) -> Void)? = nil ) {
        
        let baseURL = "https://api.vk.com"
        
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "order": "name",
            "fields": "photo_100",
            "v": "5.87",
            "user_id": Session.instance.userId
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global()){ (response) in
            
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
    
    
}
