//
//  UIView+Extension.swift
//
//  Created by Sudhir on 12/02/24.
//  Copyright © 2024 Sudhir. All rights reserved.
//

import UIKit

extension UIView {
    
    /// The radius to use when drawing rounded corners for the layer’s background.
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    /// The width of the layer’s border.
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    ///The color of the layer’s border.
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    /// The blur radius (in points) used to render the layer’s shadow. 
    ///
    /// You specify the radius The default value of this property is 3.0.
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    /// The opacity of the layer’s shadow. 
    ///
    /// The value in this property must be in the range 0.0 (transparent) to 1.0 (opaque). The default value of this property is 0.0.
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// The offset (in points) of the layer’s shadow.
    ///
    /// The default value of this property is (0.0, -3.0).
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    /// The color of the layer’s shadow.
    ///
    /// The default value of this property is an opaque black color.
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    /// Set rounded corner by height (height/2)
    @IBInspectable var roundedByHeight:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self.layer.cornerRadius = self.frame.height / 2
                    self.layer.masksToBounds = true;
                })
            }
        }
        
    }
    /// Rounded box with shadow and boder by height.
    ///
    ///  Before using this you must set require properties i.e border, shadow and corner radius
    @IBInspectable var roundedWithShadowBorderByHeight: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.bounds.height/2
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor

                })
            }
        }
    }
    /// Rounded box with shadow and boder.
    ///
    ///  Before using this you must set require properties i.e border, shadow and corner radius
    @IBInspectable var cornerradiusWithShadow: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.cornerRadius
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor
                })
            }
        }
    }
    /// Set rounded corner to given corners only.
    /// - Parameters:
    ///     - corners:  The corners of a rectangle.
    ///     - radius:  The radius to use when drawing rounded corners for the layer’s background.
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    /// Creates an image from a set of drawing instruction from current view
     func asImage() -> UIImage {
         let renderer = UIGraphicsImageRenderer(bounds: bounds)
         return renderer.image { rendererContext in
             layer.render(in: rendererContext.cgContext)
         }
     }
    
    /// Helps to set border with corner radius.
    /// - Parameters:
    ///     - width: The width of the layer’s border.
    ///     - borderColour: The color of the layer’s border.
    ///     - cornerRadius: The radius to use when drawing rounded corners for the layer’s background.

    func setBorder( _ width : CGFloat ,_ borderColour : UIColor? = nil ,_ cornerRadius : CGFloat? = 0){
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.borderColor = borderColour?.cgColor
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
