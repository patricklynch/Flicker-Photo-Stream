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
    
    static let persistentStorePath          = "applicationsqlite"
    static let managedObjectModelName       = "Application"
    static let managedObjectModelVersion    = "1.0"
    
    private static var sharedCoreDataManager: CoreDataManager = {
        let docsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let persistentStoreURL = docsDirectory.URLByAppendingPathComponent( persistentStorePath )
        
        let momPath = ("\(managedObjectModelName).momd" as NSString).stringByAppendingPathComponent( managedObjectModelVersion )
        guard let momURLInBundle = NSBundle.mainBundle().URLForResource( momPath, withExtension: "mom" ) else {
            fatalError( "Cannot find managed object model (.mom) for URL in bundle: \(momPath)" )
        }
        
        return CoreDataManager(
            persistentStoreURL: persistentStoreURL,
            currentModelVersion: CoreDataManager.ModelVersion(
                identifier: managedObjectModelVersion,
                managedObjectModelURL: momURLInBundle
            ),
            previousModelVersion: nil
        )
    }()
    
    var mainContext: NSManagedObjectContext {
        return ApplicationPersistentStore.sharedCoreDataManager.mainContext
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        return ApplicationPersistentStore.sharedCoreDataManager.createChildContext(.PrivateQueueConcurrencyType)
    }
}
