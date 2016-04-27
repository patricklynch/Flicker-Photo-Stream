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
    var url: NSURL { get }
    var format: String { get }
}

struct DefaultNetworkConfig: NetworkConfig {
    let secret = "cef569e263a3cf7a"
    let key = "a6dc5405ec56f78c3392d34df6ec1ec7"
    let format = "json"
    let method = "flickr.photos.getRecent"
    let url = NSURL(string: "https://api.flickr.com/services/rest?method=flickr.photos.getRecent&api_key=a6dc5405ec56f78c3392d34df6ec1ec7&format=json&nojsoncallback=1")!
}
