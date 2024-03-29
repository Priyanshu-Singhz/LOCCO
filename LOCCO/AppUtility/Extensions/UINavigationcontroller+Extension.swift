//
//  UINavigationcontroller+Extension.swift
//  SilvaTree
//
//  Created by Sudhir on 12/02/24.
//  Copyright © 2024 Sudhir. All rights reserved.
//

import UIKit

extension UINavigationController {
    /// Pop's give type of viewcontroller from the navigation.
    func SMPop(toController:AnyClass, animated:Bool) -> Bool {
        let resultVC = self.viewControllers.first { (vc) -> Bool in
            return vc.isKind(of: toController)
        }
        if let toVc = resultVC{
            self.popToViewController(toVc, animated: animated)
        }
        return resultVC != nil
    }
    /// Helps to find given viewcontroller from the navigation
    func SMFind(_ viewController:AnyClass) -> UIViewController? {
        return self.viewControllers.first { (vc) -> Bool in
            return vc.isKind(of: viewController)
        }
    }
    
    /// Helps to find given viewcontroller from the navigation
    func isViewControllerInstack(_ viewController:AnyClass) -> Bool {
        return self.viewControllers.contains(where: {  return $0.isKind(of: viewController)})
    }
    
    /// Pop viewcontroller with completion handler
    func popViewControllerWithHandler(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func fadeAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
    }
    
    /// Pop's give type of viewcontroller from the navigation.
    func appRemoveAllController(_ toController:AnyClass) {
        var allVC = self.viewControllers
        allVC.removeAll { return $0.isKind(of: toController)}
        self.setViewControllers(allVC, animated: false)
    }
    
    /// Pop's give type of viewcontroller from the navigation.
    func appRemoveAllController(_ toVCS:[AnyClass]) {
        var allVC = self.viewControllers
        allVC.removeAll { currentVC in
            return toVCS.contains { object in
                return currentVC.isKind(of: object)
            }
        }
        self.setViewControllers(allVC, animated: false)
    }
}
