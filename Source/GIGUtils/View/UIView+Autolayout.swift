//
//  UIView+Extension.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 7/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


public extension UIView {

    public func addSubviewWithAutolayout(childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(childView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[childView]|",
                options: .AlignmentMask,
                metrics: nil,
                views: ["childView" : childView]
            )
        )
        
        constraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[childView]|",
                options: .AlignmentMask,
                metrics: nil,
                views: ["childView" : childView]
            )
        )
        
        self.addConstraints(constraints)
        self.setNeedsUpdateConstraints()
    }
    
}