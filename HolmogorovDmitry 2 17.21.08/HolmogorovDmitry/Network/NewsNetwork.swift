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

class NewsNetwork {
    
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
  
    
}
