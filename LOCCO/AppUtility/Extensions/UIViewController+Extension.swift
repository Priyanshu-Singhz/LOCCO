//
//  UIViewController+Extension.swift
//  VetPrompter
//
//  Created by Quest on 17/06/23.
//

import UIKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    func showAlert(title:String? = nil, message:String, actions:[UIAlertAction] = [], handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.count > 0 {
            actions.forEach({alert.addAction($0)})
        } else {
            let actionOkay = UIAlertAction(title: "Okay", style: .default, handler: handler)
            alert.addAction(actionOkay)
        }
        present(alert, animated: true)
    }
    func presentFullScreen(_ vc: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle  = .fullScreen
        present(vc, animated: true, completion: completion)
    }
    
    
    func showShareConroller(_ items:[Any]) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    // Define a function to create and configure the button configuration
    func createButtonConfiguration(_ imagePlacement: NSDirectionalRectEdge = .leading) -> UIButton.Configuration {
        // Create a button configuration
        var buttonConfig = UIButton.Configuration.plain()
        // Set the insets for the image
        let inset: CGFloat = 8.0
        // Configure the button configuration
        buttonConfig.imagePadding = inset
        buttonConfig.imagePlacement = imagePlacement
        return buttonConfig
    }
}
