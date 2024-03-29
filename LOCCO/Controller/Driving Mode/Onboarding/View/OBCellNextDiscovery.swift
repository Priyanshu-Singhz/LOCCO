//
//  OBCellNextDiscovery.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 11/03/24.
//

import UIKit

class OBCellNextDiscovery: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var imgvBottom: UIImageView!
    @IBOutlet weak var viewSpeech: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //Add triangle to speech bubble
        viewSpeech.addPikeOnView(side: .Top)
    }
    /// Setup UI accorrding given information
    /// - Parameters:
    ///     - item:  it should be ModelDrivingOnboarding.
    func setupCell(_ item:ModelDrivingOnboarding) {
        lblTitle.text = item.title?.translated
        lblDescription.text = item.description?.translated
        lblBottom.text = item.othertext?.translated
        imgvBottom.image = item.otherImage
        
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
            self.viewSpeech.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }
    }
    
}
