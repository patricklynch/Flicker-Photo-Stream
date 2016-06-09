//
//  UIKIt+Extensions.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

/// Returns the name of a class by itself (without any package name)
func StringFromClass(aClass: AnyClass) -> String {
    var className = (NSStringFromClass(aClass) as NSString)
    if className.pathExtension.characters.count > 0 {
        className = className.pathExtension
    }
    return className as String
}

extension UIViewController {
    
    /// Loads a view controller from a storyboard named `storyboardName` with identifier `identifier`.
    /// If either parameter are ommitted, the name of the generic type `T` as a string will be used for both.
    static func fromStoryboard<T: UIViewController>( storyboardName: String? = nil, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? StringFromClass(self), bundle: nil )
        return storyboard.instantiateViewControllerWithIdentifier( identifier ?? StringFromClass(self) ) as! T
    }
    
    /// Loads the iniitial view conroller from a storyboard named `storybaordName`.
    /// If it is ommitted, the name of the generic type `T` as a string will be used instead.
    static func initialViewControllerFromStoryboard<T: UIViewController>( storyboardName: String? = nil ) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? StringFromClass(self), bundle: nil )
        return storyboard.instantiateInitialViewController() as! T
    }
}

extension UIView {
    
    /// Loads a nib named `nibNameOrNib`, iterates through each of the views within and returns
    /// the first one whose type matches generic type `T`.
    static func fromNib<T: UIView>(nibNameOrNil: String? = nil) -> T {
        let name = nibNameOrNil ?? StringFromClass(self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for view in nibViews {
            if let typedView = view as? T {
                return typedView
            }
        }
        fatalError( "Could not load view from nib named: \(name)" )
    }
}
