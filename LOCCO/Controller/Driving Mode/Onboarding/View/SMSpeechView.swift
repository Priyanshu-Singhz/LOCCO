//
//  SMSpeechView.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 11/03/24.
//

import Foundation
import UIKit
public extension UIView {
    ///sides of triaagle you want. Triangle will be shown in center
    enum PeakSide: Int {
        /// It will show Pik at top center
        case Top
        /// It will show Pik at left center
        case Left
        /// It will show Pik at right center
        case Right
        /// It will show Pik at bottom center
        case Bottom
    }
    ///Get or set Heigh of triangle
    var triAngleHeight:CGFloat {
        return 10.0
    }
    
    /// Helps to add Triaabgle according given direction
    /// - Parameters:
    ///     - side:  It should be PeakSide (Top, Left,  Right or Bottom )
    func addPikeOnView(side: PeakSide) {
        self.layoutIfNeeded()
        self.layer.sublayers?.forEach({ sblyr in
            if sblyr.accessibilityHint == "peakLayer" { sblyr.removeFromSuperlayer() }
        })
        let peakLayer = CAShapeLayer()
        peakLayer.accessibilityHint = "peakLayer"
        var path: CGPath?
        switch side {
        case .Top:
            path = self.makeTop(rect: self.bounds)
        case .Left:
            path = self.makeTop(rect: self.bounds)
        case .Right:
            path = self.makeTop(rect: self.bounds)
        case .Bottom:
            path = self.makeBottom(rect: self.bounds)
        }
        peakLayer.path = path
        let color = (self.backgroundColor ?? .clear).cgColor
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        self.layer.insertSublayer(peakLayer, at: 0)
    }
    /// Top center triangle for given rect
    /// - Parameters:
    ///     - rect:  It should be CGRect.
    func makeTop(rect: CGRect) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: (rect.width/2), y: -triAngleHeight))
        path.addLine(to: CGPoint(x:(rect.width/2) + triAngleHeight, y: 0))
        path.addLine(to: CGPoint(x:(rect.width/2) - triAngleHeight, y:0))
        path.addLine(to: CGPoint(x:(rect.width/2), y:-triAngleHeight))
        path.closeSubpath()
        return path
    }
    /// Bottom center triangle for given rect
    /// - Parameters:
    ///     - rect:  It should be CGRect.
    func makeBottom(rect: CGRect) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: (rect.width/2), y: (rect.height + triAngleHeight)))
        path.addLine(to: CGPoint(x:(rect.width/2) + triAngleHeight, y: rect.height))
        path.addLine(to: CGPoint(x:(rect.width/2) - triAngleHeight, y:rect.height))
        path.addLine(to: CGPoint(x:(rect.width/2), y:(rect.height + triAngleHeight)))
        path.closeSubpath()
        return path
    }
    
    
}
