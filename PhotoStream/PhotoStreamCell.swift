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
    
    /// Represents the necessary configuration data for this view
    struct ViewData {
        let imageURL: NSURL?
        let caption: String
    }
    
    var viewData: ViewData? {
        didSet {
            if let viewData = viewData where viewData.imageURL != oldValue?.imageURL {
                imageView.alpha = 0.0
                if let imageURL = viewData.imageURL {
                    imageView.sd_setImageWithURL(imageURL) { image, error, cacheType, url in
                        guard cacheType == .None else {
                            // If we were cached from disk/memory, the image is avialable
                            // immediately and we don't need to animate
                            self.imageView.alpha = 1.0
                            return
                        }
                        UIView.animateWithDuration(0.3) {
                            cacheType
                            self.imageView.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // They key to smooth scrolling performance in table- and collectionViews is to NOT use autolayout
        // It's a bit more complicated to do frames and bounds the old school way, but this will
        // be smooth enough to run on a old, slow iPod touch
        
        imageView.frame = bounds
    }
    
    // MARK: - SelfSizingCell
    
    func cellSize(withinBounds bounds: CGRect) -> CGSize {
        return CGSize(width: bounds.width, height: bounds.width) //< Square
    }
}
