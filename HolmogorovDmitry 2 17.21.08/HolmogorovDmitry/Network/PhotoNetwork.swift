//
//  PhotoNetwork.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 26/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import Foundation
import  Alamofire
import  SwiftyJSON

class PhotoNetwork {
    
    static func urlForPhoto(_ photo: String) -> URL? {
        return URL(string: photo)
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
                let photo = json["response"]["items"].arrayValue.map { MyPhoto(json: $0) }
                
                completion?(photo, nil)
            }
        }
    }
    
}
