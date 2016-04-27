//
//  NSManagedObjectContext+Perform.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    /// An extension of `performBlock(_:)` that includes the receiver as the first argument in the block.
    /// Executes asynchronously on the receiver's appropriate queue and provides the context as the single
    /// parameter of the block as well as the return type.  This adapters the vanilla `performBlock`
    /// for more functional-style proramming where things are chained, nested, etc.
    func ext_performBlock(block: NSManagedObjectContext -> Void) -> NSManagedObjectContext {
        performBlock() {
            block(self)
        }
        return self
    }
    
    /// An extension of `ext_performBlockAndWait(_:)` that includes the receiver as the first argument in the block.
    /// Executes synchronously on the receiver's appropriate queue.
    func ext_performBlockAndWait<T>(block: NSManagedObjectContext -> T) -> T {
        var result: T?
        performBlockAndWait() {
            result = block(self)
        }
        return result!
    }
    
    /// Executes a fetch request exactly as by calling `executeFetchRequest(_:)` except that any
    /// errors are caught internally and an empty array is results as a result
    func ext_executeFetchRequest<T: NSManagedObject>(request: NSFetchRequest) -> [T] {
        let results: [T]
        do {
            results = try executeFetchRequest( request ) as? [T] ?? []
        } catch {
            results = []
        }
        return results
    }
    
    func ext_executeRequest(request: NSPersistentStoreRequest) -> NSPersistentStoreResult? {
        do {
            return try executeRequest( request )
        } catch {
        }
        return nil
    }
    
    /// Performs a save to the receiver and subsequently the reciever's `parentContext`,
    /// if defined. Also catches any exceptions, throws an assertion failure and
    /// logs detailed error messages to the console.
    func ext_saveAndBubbleToParentContext() {
        ext_save()
        parentContext?.ext_performBlockAndWait() { context in
            context.ext_save()
        }
    }
    
    /// Performs a save to the receiver and catches any exceptions, throws an assertion
    /// failure and logs detailed error messages to the console.
    func ext_save() {
        do {
            try self.save()
        } catch {
            var message = "\n\n *** FAILED TO SAVE! ***\n"
            let userInfo = (error as NSError).userInfo
            var managedObject: NSManagedObject?
            if let detailedErrors = userInfo[ "NSDetailedErrors" ] as? [NSError] {
                for detailedError in detailedErrors {
                    if let validationField = detailedError.userInfo[ "NSValidationErrorKey" ] as? String,
                        let object = detailedError.userInfo[ "NSValidationErrorObject" ] as? NSManagedObject {
                        managedObject = object
                        message += "\n - Missing value for non-optional field \"\(validationField)\" on object \(managedObject?.dynamicType)."
                    }
                }
            }
            else if let validationField = userInfo[ "NSValidationErrorKey" ] as? String,
                let object = userInfo[ "NSValidationErrorObject" ] as? NSManagedObject {
                managedObject = object
                message += "\n - Missing value for non-optional field \"\(validationField)\" on object \(managedObject?.dynamicType)."
            }
            assertionFailure()
        }
    }
}