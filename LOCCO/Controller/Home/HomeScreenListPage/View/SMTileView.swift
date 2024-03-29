//
//  SMTileView.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 19/02/24.
//

import UIKit

class SMTileView: UIView {
    @IBInspectable var isEnabletouchAnimation:Bool = false
    
    var tileDidClicked:(() -> ())? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabletouchAnimation {
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabletouchAnimation {
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                self.transform = .identity
            }) { finish in
                self.tileDidClicked?()
            }
        }
    }
}
