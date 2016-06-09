//
//  PhotoStreamDataSource.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class PhotoStreamDataSource: NSObject, ExtendedCollectionViewDataSource {
    
    var networkConfig: NetworkConfig = DefaultNetworkConfig()
    
    private let sizingCell: PhotoStreamCell = PhotoStreamCell.fromNib()
    
    private let networkingQueue = NSOperationQueue()
    
    private(set) var photos = [Photo]()
    
    private func decorateCell(cell: PhotoStreamCell, atIndexPath indexPath: NSIndexPath) {
        let photo = photos[indexPath.row]
        cell.imageURL = photo.imageURL(networkConfig) //< cell prevents loading too often
        cell.caption = photo.title
    }
    
    // MARK: ExtendedCollectionViewDataSource
    
    func reload(completion:()->()) {
        let loadOperation = LoadPhotoStreamOperation()
        loadOperation.networkConfig = networkConfig
        loadOperation.completionBlock = { [weak self] in
            dispatch_async(dispatch_get_main_queue()) {
                self?.photos = loadOperation.results ?? []
                completion()
            }
        }
        networkingQueue.addOperation(loadOperation)
    }
    
    func registerCells(collectionView: UICollectionView) {
        collectionView.registerNib( UINib(nibName: "PhotoStreamCell", bundle: nil), forCellWithReuseIdentifier: "PhotoStreamCell" )
    }
    
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        decorateCell(sizingCell, atIndexPath: indexPath)
        return sizingCell.cellSize(withinBounds: collectionView.bounds)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoStreamCell", forIndexPath: indexPath) as! PhotoStreamCell
        decorateCell(cell, atIndexPath: indexPath)
        return cell
    }
}
