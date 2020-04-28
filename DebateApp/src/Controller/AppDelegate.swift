//
//  AppDelegate.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/02.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: InitialViewController())
        var window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Define the menus
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: InitialViewController())
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        
        // Setup gestures: the left and/or right menus must be set up (above) for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: navigationController.view, forMenu: .left)
        
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


}

