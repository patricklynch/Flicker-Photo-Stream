//
//  Queueable.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

/// A customization designed for NSOperation that defines an object with
/// a completion block type specific to its purposes and some convenience
/// methods for adding it to an NSOperationQueue.
protocol Queueable {
    
    /// Conformers are required to define a completion block type that is
    /// specific to the actions it performs.  This allows calling code to have
    /// meaningful completion blocks that pass back results or other data.
    associatedtype CompletionBlockType
    
    /// Conformers must handle executing their own completion block in order
    /// to provide data typed to its signature.
    func executeCompletionBlock(completionBlock: CompletionBlockType)
    
    /// Adds the operation to the provided queue and sets up the typed completion
    /// block to be called from the standard ()->() block of NSOperation.
    func queueOn(queue: NSOperationQueue, completion: CompletionBlockType?)
}

extension Queueable where Self : NSOperation {
    
    func queueOn(queue: NSOperationQueue, completion: CompletionBlockType?) {
        queue.addOperation(self, completion: completion)
    }
}

extension NSOperationQueue {
    
    func addOperation<T: Queueable where T : NSOperation>( operation: T, completion: T.CompletionBlockType? ) {
        if let completion = completion {
            operation.completionBlock = { [weak operation] in
                operation?.executeCompletionBlock(completion)
            }
        }
        addOperation( operation )
    }
}
