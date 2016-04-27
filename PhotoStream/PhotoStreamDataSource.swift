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
    
    var networkConfig: NetworkConfig = DefaultNetworkConfig()
    
    let sizingCell: PhotoStreamCell = PhotoStreamCell.v_fromNib()
    
    var error: NSError?
    
    private let networkingQueue = NSOperationQueue()
    
    private(set) var photos = [Photo]()
    
    func reload(completion:(()->())? = nil) {
        let loadOperation = LoadPhotoStreamOperation()
        loadOperation.networkConfig = networkConfig
        loadOperation.queueOn(networkingQueue) { [weak self] results, error in
            if let error = error {
                self?.error = error
            } else {
                self?.photos = results as? [Photo] ?? []
            }
            completion?()
        }
    }
    
    private func decorateCell(cell: PhotoStreamCell, atIndexPath indexPath: NSIndexPath) {
        let photo = photos[indexPath.row]
        let viewData = PhotoStreamCell.ViewData(
            imageURL: photo.imageURL(networkConfig),
            caption: photo.title)
        cell.viewData = viewData
    }
    
    // MARK: ExtendedCollectionViewDataSource
    
    func registerCells(collectionView: UICollectionView) {
        collectionView.registerNib( UINib(nibName: "PhotoStreamCell", bundle: nil),
                                    forCellWithReuseIdentifier: "PhotoStreamCell")
        collectionView.registerNib( UINib(nibName: "ErrorCell", bundle: nil),
                                    forCellWithReuseIdentifier: "ErrorCell")
    }
    
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if error == nil {
            decorateCell(sizingCell, atIndexPath: indexPath)
            return sizingCell.cellSize(withinBounds: collectionView.bounds)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 100.0)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if error != nil {
            return 1
        } else {
            return photos.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let error = self.error {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ErrorCell", forIndexPath: indexPath) as! ErrorCell
            cell.text = NSLocalizedString("Error loading results!", comment: "") + "\n" + error.localizedDescription
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoStreamCell", forIndexPath: indexPath) as! PhotoStreamCell
            decorateCell(cell, atIndexPath: indexPath)
            return cell
        }
    }
}
