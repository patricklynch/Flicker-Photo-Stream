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
    
    // These are vars instead of lets so that they can be easily mocked in unit tests
    var networkConfig: NetworkConfig = DefaultNetworkConfig()
    var persistentStore: PersistentStoreType = ApplicationPersistentStore()
    
    let method = "flickr.photos.getRecent"
    
    override func start() {
        beganExecuting()
        
        let url = networkConfig.url(method)
        let urlRequest = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let (data, _, networkError) = urlSession.synchronousDataTaskWithURL(urlRequest)
        
        if let error = networkError {
            self.error = error
            
        } else if let data = data,
            let response = RecentPhotosResponse(json: JSON(data: data)) {
            
            // Parse photos into persistent store using background context/thread
            let backgroundParsedPhotos: [Photo] = persistentStore.createBackgroundContext().ext_performBlockAndWait() { context in
                
                // Map each JSON source to a `Photo` model
                let newPhotos: [Photo] = response.photosPayload.photos.flatMap { photoJSON in
                    guard let entity = NSEntityDescription.entityForName(Photo.entityName, inManagedObjectContext: context),
                        let photo = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context) as? Photo else {
                        return nil
                    }
                    if photo.populate(fromJSON: photoJSON) {
                        return photo
                    } else {
                        return nil
                    }
                }
                
                // We have to save first before objectIDs are generated for newly-created NSManagedObjects
                context.ext_saveAndBubbleToParentContext()
                return newPhotos
            }
            
            // Read those results back from the main context/thread using the object IDs
            let parsedObjectIDs: [NSManagedObjectID] = backgroundParsedPhotos.map { $0.objectID }
            persistentStore.mainContext.ext_performBlockAndWait() { context in
                let photos = parsedObjectIDs.flatMap { context.objectWithID($0) as? Photo }
                self.results = photos
            }
            
        } else {
            error = NSError(domain: "", code: 1, userInfo: ["reason" : "Failed to parse response."])
        }
    
        finishedExecuting()
    }
}
