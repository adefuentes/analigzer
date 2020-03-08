//
//  ViewExtension.swift
//  HBO
//
//  Created by Angel Fuentes on 09/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(visualFormat: String, views: UIView...) {
        
        var _views: [String: UIView] = [:]
        
        for (key, value) in views.enumerated() {
            _views["v\(key)"] = value
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                           options: [], metrics: nil, views: _views))
        
    }
    
    func centerVerticalWithConstraints(_ subview: UIView) {
        
        self.addConstraint(NSLayoutConstraint(item: subview,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
        
    }
    
    func centerHorizontalWithConstraints(_ subview: UIView) {
        
        self.addConstraint(NSLayoutConstraint(item: subview,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        
    }
    
    func centerWithConstraints(_ subview: UIView) {
        
        self.centerVerticalWithConstraints(subview)
        self.centerHorizontalWithConstraints(subview)
        
    }
    
    
}
