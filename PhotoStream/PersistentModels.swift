//
//  PersistentModels.swift
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
    @NSManaged var id: String
    @NSManaged var owner: String
    @NSManaged var secret: String
    @NSManaged var server: String
    @NSManaged var farm: NSNumber
    @NSManaged var title: String
    @NSManaged var isPublic: Bool
    @NSManaged var isFriend: Bool
    @NSManaged var isFamily: Bool
}

extension Photo: JSONParsable {
    func populate(fromJSON json: JSON) -> Bool {
        
        guard let id = json["id"].string else {
            return false
        }
        
        self.id = id
        return true
    }
}
