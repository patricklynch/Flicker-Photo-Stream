//
//  Photo.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import CoreData

protocol JSONParsable {
    func populate(fromJSON json: JSON) -> Bool
}

class Photo: NSManagedObject {
    static var entityName = "Photo"
    
    @NSManaged var farm: Int
    @NSManaged var id: String
    @NSManaged var isFamily: Bool
    @NSManaged var isFriend: Bool
    @NSManaged var isPublic: Bool
    @NSManaged var owner: String
    @NSManaged var secret: String
    @NSManaged var server: String
    @NSManaged var title: String
    @NSManaged var imageURL: String
}

extension Photo: JSONParsable {
    func populate(fromJSON json: JSON) -> Bool {
        
        guard let id = json["id"].string,
            let owner = json["owner"].string,
            let secret = json["secret"].string,
            let server = json["server"].string,
            let farm = json["farm"].int,
            let title = json["title"].string,
            let isPublic = json["ispublic"].int,
            let isFriend = json["isfriend"].int,
            let isFamily = json["isfamily"].int else {
            return false
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
        return true
    }
}

extension Photo {
    func imageURL(networkConfig: NetworkConfig, fileExtension: String = "jpg") -> NSURL? {
        let format = networkConfig.imageURLFormat
        let formatted = NSString(format: format, farm, server, id, secret, fileExtension)
        return NSURL(string: formatted as String)
    }
}
