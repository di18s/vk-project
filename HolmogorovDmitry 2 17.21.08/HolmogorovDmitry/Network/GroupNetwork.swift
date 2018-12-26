//
//  GroupNetwork.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 26/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import  Alamofire
import  SwiftyJSON

class GroupNetwork {
    
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
}
