//
//  UIStoryboard+Extension.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 13/02/24.
//

import UIKit
extension UIStoryboard {
    func viewController<T: UIViewController>(_ type: T.Type) -> T? {
        let vcID = (type as UIViewController.Type).storyboardID
        return self.instantiateViewController(withIdentifier: vcID) as? T
    }
}
