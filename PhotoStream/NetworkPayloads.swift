//
//  NetworkPayloads.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RecentPhotosResponse {
    let photosPayload: PhotosPayload
    let status: String
    
    init?(json: JSON) {
        guard let photosPayload = PhotosPayload(json: json["photos"]),
            let status = json["stat"].string else {
                return nil
        }
        self.photosPayload = photosPayload
        self.status = status
    }
}

struct PhotosPayload {
    let currentPage: Int
    let totalPages: Int
    let itemsPerPage: Int
    let totalItems: Int
    let photos: [JSON]
    
    init?(json: JSON) {
        guard let currentPage = json["page"].int,
            let totalPages = json["pages"].int,
            let itemsPerPage = json["perpage"].int,
            let totalItems = json["total"].int else {
                return nil
        }
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        
        self.photos = json["photo"].array ?? []
    }
}
