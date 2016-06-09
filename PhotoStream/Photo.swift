//
//  Photo.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

struct Photo {    
    let farm: Int
    let id: String
    let isFamily: Bool
    let isFriend: Bool
    let isPublic: Bool
    let owner: String
    let secret: String
    let server: String
    let title: String
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            let owner = json["owner"].string,
            let secret = json["secret"].string,
            let server = json["server"].string,
            let farm = json["farm"].int,
            let title = json["title"].string,
            let isPublic = json["ispublic"].int,
            let isFriend = json["isfriend"].int,
            let isFamily = json["isfamily"].int else {
                return nil
        }
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isPublic = Bool(isPublic)
        self.isFriend = Bool(isFriend)
        self.isFamily = Bool(isFamily)
    }
    
    func imageURL(networkConfig: NetworkConfig, fileExtension: String = "jpg") -> NSURL? {
        let format = networkConfig.imageURLFormat
        let formatted = NSString(format: format, farm, server, id, secret, fileExtension)
        return NSURL(string: formatted as String)
    }
}