//
//  AppDelegate.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/02/24.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureGoogle()
        APPGloble.configureToastView()
        configureIQKeyboard()
        APPGloble.configureScrollIndicator()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    //MARK: - navigation
    func switchToHome()  {
        let dashboard = AppStoryboard.home.instantiateViewController(withIdentifier: "NavigationHome")
        animatedAddtoRoot(dashboard)
    }
    
    func switchToWelCome()  {
        let dashboard = AppStoryboard.main.instantiateViewController(withIdentifier: "WelcomePageVC")
        let navigationWelcome = UINavigationController(rootViewController: dashboard)
        navigationWelcome.isNavigationBarHidden = true
        animatedAddtoRoot(navigationWelcome)
    }
    
    fileprivate func animatedAddtoRoot(_ toView:UIViewController) -> Void {
        guard UIApplication.shared.firstKeyWindow != nil else { return }
        UIApplication.shared.firstKeyWindow?.rootViewController = toView
        UIApplication.shared.firstKeyWindow?.makeKeyAndVisible()
        UIView.transition(with: UIApplication.shared.firstKeyWindow!, duration: 0.5, options: .transitionCrossDissolve, animations: {}, completion: nil)
    }
    
    //MARK: Helpers

    func configureIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.appSkyBlue
    }
    
    func configureGoogle() {
        let config = GIDConfiguration(clientID: APPCredentials.googleClientKey)
        GIDSignIn.sharedInstance.configuration = config
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

    }
    
    static var appDelegate:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
