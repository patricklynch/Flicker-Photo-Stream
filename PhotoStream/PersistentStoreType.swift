//
//  PersistentStoreType.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation
import CoreData

/// Defines an object that provides access to a persistent backed by CoreData that exposes
/// its internally configured and managed instances of `NSManagedObjectContext` which are the
/// primary interfaces through which application code should interact.
protocol PersistentStoreType {
    
    /// A context used primarily for reads that should only ever be accessed from the main queue.
    /// To ensure this, always call `performBlock(_:)` or `performBlockAndWait(_:)` when interacting
    /// with this context.
    var mainContext: NSManagedObjectContext { get }
    
    /// A context used primarily for asynchronous writes that should only ever be accessed from
    /// the propery queue by calling `performBlock(_:)` or `performBlockAndWait(_:)` when interacting
    /// with this context.
    func createBackgroundContext() -> NSManagedObjectContext
}