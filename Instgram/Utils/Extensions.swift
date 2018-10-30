//
//  Extensions.swift
//  Instgram
//
//  Created by Mahmoud Mohammed on 9/9/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    
    /// this function is used to anchor any uiview from its four sides
    /// if you don`t want to use any side just enter it by nil value
    /// if you don`t want to enter specific height or width just enter it by 0 value
    ///
    /// - Parameters:
    ///   - top: NSLayoutConstraint to ancor TheView From Top
    ///   - left: NSLayoutConstraint to ancor TheView From left
    ///   - bottom: NSLayoutConstraint to ancor TheView From bottom
    ///   - right: NSLayoutConstraint to ancor TheView From right
    ///   - paddingTop: space between (the view Top side) and parameter: top
    ///   - paddingLeft: space between (the view Left side) and parameter: left
    ///   - paddingBottom: space between (the view Bottom side) and parameter: bottom
    ///   - paddingRight: space between (the view Right side) and parameter: right
    ///   - width: the View Width if needed
    ///   - height: the view Height if needed
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant:  -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
