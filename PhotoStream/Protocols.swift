//
//  Protocols.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 6/8/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import Foundation

protocol ExtendedCollectionViewDataSource: UICollectionViewDataSource {
    func reload(completion:()->())
    func registerCells(collectionView: UICollectionView)
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
}

protocol SelfSizingCell: class {
    func cellSize(withinBounds bounds: CGRect) -> CGSize
}
