//
//  NSURLSession+Sync.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

extension NSURLSession {
    
    func synchronousDataTaskWithURL(urlRequest: NSURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        var data: NSData?, response: NSURLResponse?, error: NSError?
        
        let semaphore = dispatch_semaphore_create(0)
        
        dataTaskWithRequest(urlRequest) {
            data = $0; response = $1; error = $2
            dispatch_semaphore_signal(semaphore)
        }.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        return (data, response, error)
    }
}
