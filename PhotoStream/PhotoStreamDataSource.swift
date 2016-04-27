//
//  PhotoStreamDataSource.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

/// The purpose behind this "extended" protocol is to put all responsibility for handling
/// the cells to the data source.  It registers them, dequeues them, decorates them, sizes
/// them, etc.  The view controller and the collection view delegate needn't know the
/// specific cell class involved.
protocol ExtendedCollectionViewDataSource: class {
    func registerCells(collectionView: UICollectionView)
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
}

class PhotoStreamDataSource: NSObject, UICollectionViewDataSource, ExtendedCollectionViewDataSource {
    
    let sizingCell: PhotoStreamCell = PhotoStreamCell.v_fromNib()
    
    private let networkingQueue = NSOperationQueue()
    
    private(set) var visibleItems = [Photo]()
    
    func reload(completion:(()->())? = nil) {
        LoadPhotoStreamOperation().queueOn(networkingQueue) { results, error in
         
            if let error = error {
                print("Error: \(error)")
            } else {
                print(results)
            }
            
            completion?()
        }
    }
    
    private func decorateCell(cell: PhotoStreamCell, atIndexPath indexPath: NSIndexPath) {
        let visibleItem = visibleItems[indexPath.row]
        // TODO: Decorate
    }
    
    // MARK: ExtendedCollectionViewDataSource
    
    func registerCells(collectionView: UICollectionView) {
        collectionView.registerNib( UINib(nibName: "PhotoStreamCell", bundle: nil), forCellWithReuseIdentifier: "PhotoStreamCell")
    }
    
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let visibleItem = visibleItems[indexPath.row]
        decorateCell(sizingCell, atIndexPath: indexPath)
        return sizingCell.cellSize(withinBounds: collectionView.bounds)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let visibleItem = visibleItems[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoStreamCell", forIndexPath: indexPath) as! PhotoStreamCell
        decorateCell(cell, atIndexPath: indexPath)
        return cell
    }
}
