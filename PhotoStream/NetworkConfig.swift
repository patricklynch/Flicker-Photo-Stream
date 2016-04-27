//
//  NetworkConfig.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

protocol NetworkConfig {
    var secret: String { get }
    var key: String { get }
    var format: String { get }
    var baseURL: String { get }
    var imageURLFormat: String { get }
    func url(method: String) -> NSURL
}

struct DefaultNetworkConfig: NetworkConfig {
    let secret = "cef569e263a3cf7a"
    let key = "a6dc5405ec56f78c3392d34df6ec1ec7"
    let format = "json"
    let method = "flickr.photos.getRecent"
    let baseURL = "https://api.flickr.com/services/rest"
    let imageURLFormat = "https://farm%i.staticflickr.com/%@/%@_%@_z.%@"
    
    func url(method: String) -> NSURL {
        let urlString = baseURL
            + "?method=\(method)"
            + "&api_key=a6dc5405ec56f78c3392d34df6ec1ec7"
            + "&format=json"
            + "&nojsoncallback=1"
        return NSURL(string: urlString)!
    }
}
