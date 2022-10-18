//
//  AppDelegate.swift
//  OpenClose
//
//  Created by Jeytery on 18.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let tabBarController = UITabBarController()
        
        tabBarController.setViewControllers([UINavigationController(rootViewController:  MenuViewController()), UINavigationController(rootViewController:  Menu2ViewController())], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

