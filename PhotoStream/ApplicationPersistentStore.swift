//
//  ApplicationPersistentStore.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import CoreData

class ApplicationPersistentStore: NSObject, PersistentStoreType {
    
    static let managedObjectModelName       = "Application"
    static let managedObjectModelVersion    = "1.0"
    static let persistentStorePath          = "application.sqlite"
    
    lazy var sharedCoreDataManager: CoreDataManager = {
        
        let momPath = ("\(ApplicationPersistentStore.managedObjectModelName).momd" as NSString).stringByAppendingPathComponent( ApplicationPersistentStore.managedObjectModelVersion )
        guard let momURLInBundle = NSBundle.mainBundle().URLForResource( momPath, withExtension: "mom" ) else {
            fatalError( "Cannot find managed object model (.mom) for URL in bundle: \(momPath)" )
        }
        
        return CoreDataManager(
            persistentStoreURL: ApplicationPersistentStore.persistentStoreURL( fromPath:ApplicationPersistentStore.persistentStorePath ),
            currentModelVersion: CoreDataManager.ModelVersion(
                identifier: managedObjectModelVersion,
                managedObjectModelURL: momURLInBundle
            ),
            previousModelVersion: nil
        )
    }()
    
    static func persistentStoreURL(fromPath path: String) -> NSURL {
        let docsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return docsDirectory.URLByAppendingPathComponent( path )
    }
    
    var mainContext: NSManagedObjectContext {
        return sharedCoreDataManager.mainContext
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        return sharedCoreDataManager.createChildContext(.PrivateQueueConcurrencyType)
    }
}
