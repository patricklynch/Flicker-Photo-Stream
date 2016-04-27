//
//  ErrorCell.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class ErrorCell: UICollectionViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    var text: String? {
        didSet{
            textView.text = text
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        textView.frame = bounds
    }
}
