//
//  OBCellProgress.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 11/03/24.
//

import UIKit

class OBCellProgress: UICollectionViewCell {
    
    @IBOutlet weak var imgvMain: UIImageView!
    @IBOutlet weak var speechBubble: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewImageBase: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImageBase.layer.cornerRadius = viewImageBase.frame.height / 2
        viewImageBase.layer.masksToBounds = true;
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //Add triangle to speech bubble
        speechBubble.addPikeOnView(side: .Top)
    }
    /// Setup UI accorrding given information
    /// - Parameters:
    ///     - item:  it should be ModelDrivingOnboarding.
    func setupCell(_ item:ModelDrivingOnboarding) {
        imgvMain.image = item.image
        lblTitle.text = item.title?.translated
        lblDescription.text = item.description?.translated
        
    }
    /// Helps to animate view
    /// - Parameters:
    ///     - ishow:  Pass true for show and false to exit animation
    func animateValue(ishow:Bool) {
        if ishow {
            UIView.transition(with: speechBubble, duration: 0.2) {
                self.speechBubble.transform = .identity
            }
        } else {
            self.speechBubble.transform = CGAffineTransform(translationX: 0, y: -viewImageBase.bounds.height)
        }
    }
    
}
