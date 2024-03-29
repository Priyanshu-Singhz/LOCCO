//
//  InfoButton.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

class InfoButton: UIControl {
    @IBOutlet weak var imgvIcon: UIImageView!
    
    private var isSelectedButton:Bool = false
    

    /// Help to update state of button
    func updateSelectionState(_ newValue:Bool) {
        isSelectedButton = newValue
        updateUI()
    }
    ///Help  to rertive current state of button
    func getCurrentState() -> Bool {
        return isSelectedButton
    }

    
    fileprivate func updateUI() {
        if isSelectedButton {
            self.backgroundColor = UIColor.appSkyBlue
            self.imgvIcon.tintColor = UIColor.appWhite
        } else {
            self.backgroundColor = UIColor.appWhite
            self.imgvIcon.tintColor = UIColor.appSkyBlue
        }
    }
}
