//
//  PhotoStreamCell.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class PhotoStreamCell: UICollectionViewCell, SelfSizingCell {
    
    var caption: String? {
        didSet {
            textView.text = caption
        }
    }
    
    var imageURL: NSURL? {
        didSet {
            guard let imageURL = imageURL where imageURL != oldValue else {
                return
            }
            
            imageView.alpha = 0.0
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
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    
    private func calculateTextSize(withinBounds bounds: CGRect) -> CGSize {
        var sizeNeeded = textView.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.max))
        sizeNeeded.width = bounds.width
        return sizeNeeded
    }
    
    // MARK: - SelfSizingCell
    
    func cellSize(withinBounds bounds: CGRect) -> CGSize {
        let textSize = calculateTextSize(withinBounds: bounds)
        let mediaSize = CGSize(width: bounds.width, height: imageView.frame.height) //< Square
        return CGSize(width: bounds.width, height: textSize.height + mediaSize.height)
    }
}
