//
//  LikeNetwork.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 26/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import  Alamofire
import  SwiftyJSON

class LikeNetwork {
    
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
    
}
