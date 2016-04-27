//
//  PhotoStreamCell.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

protocol SelfSizingCell: class {
    func cellSize(withinBounds bounds: CGRect) -> CGSize
}

class PhotoStreamCell: UICollectionViewCell, SelfSizingCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - SelfSizingCell
    
    func cellSize(withinBounds bounds: CGRect) -> CGSize {
        return CGSize(width: bounds.width, height: 100.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // They key to smooth scrolling performance in table- and collectionViews is to NOT use autolayout
        // It's a bit more complicated to do frames and bounds the old school way, but this will
        // be smooth enough to run on a old, slow iPod touch
        
        imageView.frame = bounds
    }
}
