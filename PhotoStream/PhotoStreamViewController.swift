//
//  PhotoStreamViewController.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class PhotoStreamViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let dataSource = PhotoStreamDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(collectionView)
        
        dataSource.reload() {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return dataSource.collectionView(collectionView, sizeForItemAtIndexPath: indexPath)
    }
}

