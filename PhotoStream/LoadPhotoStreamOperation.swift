//
//  LoadPhotoStreamOperation.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

class LoadPhotoStreamOperation: NSOperation {
    
    let method = "flickr.photos.getRecent"
    
    var networkConfig: NetworkConfig = DefaultNetworkConfig()
    
    var results: [Photo]?
    
    override func main() {
        let url = networkConfig.url(method)
        let urlRequest = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let (data, _, networkError) = urlSession.synchronousDataTaskWithURL(urlRequest)
        if networkError == nil, let data = data,
            let response = RecentPhotosResponse(json: JSON(data: data)) {
            self.results = response.photosPayload.photos.flatMap { Photo(json: $0) }
        }
    }
}
