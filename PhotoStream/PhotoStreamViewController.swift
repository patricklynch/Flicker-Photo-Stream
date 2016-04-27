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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_: )), forControlEvents: .ValueChanged)
        self.collectionView.addSubview( refreshControl )
        return refreshControl
    }()
    
    private(set) var topInset: CGFloat = 0.0
    
    private func positionRefreshControl() {
        if let subview = refreshControl.subviews.first {
            subview.center = CGPoint(
                x: self.refreshControl.bounds.midX,
                y: self.refreshControl.bounds.midY + self.topInset * 0.5
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(collectionView)
        collectionView.dataSource = dataSource
        refresh()
    }
    
    @objc private func refresh(sender: AnyObject? = nil) {
        if sender == nil {
            self.refreshControl.beginRefreshing()
        }
        dataSource.reload() { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return dataSource.collectionView(collectionView, sizeForItemAtIndexPath: indexPath)
    }
}

