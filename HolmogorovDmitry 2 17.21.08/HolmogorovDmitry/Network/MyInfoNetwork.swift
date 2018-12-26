//
//  MyInfoNetwork.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 26/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import  Alamofire
import  SwiftyJSON

class MyInfoNetwork {
    
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
                let info = json["response"].arrayValue.map { MyInfo(json: $0) }
                
                completion?(info, nil)
            }
        }
    }
    
    
}
