//
//  LoadPhotoStreamOperation.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import CoreData
class LoadPhotoStreamOperation: BackgroundOperation {
    
    var networkConfig: NetworkConfig = DefaultNetworkConfig()
    var persistentStore: PersistentStoreType = ApplicationPersistentStore()
    
    override func start() {
        beganExecuting()
        let url = networkConfig.url
        let urlRequest = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let (data, _, error) = urlSession.synchronousDataTaskWithURL(urlRequest)
        
        if let error = error {
            self.error = error
            
        } else if let data = data,
            let response = RecentPhotosResponse(json: JSON(data: data)) {
            
            // Parse photos into persistent store using background context
            let parsedObjectIDs: [NSManagedObjectID] = persistentStore.createBackgroundContext().ext_performBlockAndWait() { context in
                var parsedPhotos = [Photo]()
                for photoJSON in response.photosPayload.photos {
                    guard let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context),
                        let photo = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context) as? Photo else {
                        continue
                    }
                    if photo.populate(fromJSON: photoJSON) {
                        parsedPhotos.append(photo)
                    }
                }
                return parsedPhotos.map { $0.objectID }
            }
            
            // Read those results back from the main context using the object IDs
            results = persistentStore.mainContext.ext_performBlockAndWait() { context in
                return parsedObjectIDs.flatMap { context.objectWithID($0) as? Photo }
            }
            
            
        } else {
            print("Failed to parse response")
        }
    
        finishedExecuting()
    }
}
