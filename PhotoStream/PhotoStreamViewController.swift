//
//  PhotoStreamViewController.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class PhotoStreamViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var dataSource: ExtendedCollectionViewDataSource = PhotoStreamDataSource() {
        didSet {
            onDataSourceUpdated()
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        onDataSourceUpdated()
    }
    
    private func onDataSourceUpdated() {
        dataSource.registerCells(collectionView)
        collectionView.dataSource = dataSource
        refresh()
    }
    
    @objc private func refresh(sender: AnyObject? = nil) {
        refreshControl.beginRefreshing()
        dataSource.reload() { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return dataSource.collectionView(collectionView, sizeForItemAtIndexPath: indexPath)
    }
    
    // MARK: - Hacky refresh control stuff
    
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
                x: refreshControl.bounds.midX,
                y: refreshControl.bounds.midY + self.topInset * 0.5
            )
        }
    }
}
