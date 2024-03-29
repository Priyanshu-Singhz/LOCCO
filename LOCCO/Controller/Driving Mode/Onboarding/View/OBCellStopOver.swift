//
//  OBCellStopOver.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/03/24.
//

import UIKit

class OBCellStopOver: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvMain: UIImageView!
    @IBOutlet weak var viewSpeech: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //Add triangle to speech bubble
        viewSpeech.addPikeOnView(side: .Bottom)
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
            UIView.transition(with: viewSpeech, duration: 0.2) {
                self.viewSpeech.transform = .identity
            }
        } else {
            self.viewSpeech.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
        }
    }
}
