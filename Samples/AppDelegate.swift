//
//  AppDelegate.swift
//  TestTwitterLogin
//
//  Created by Huang on 2022/10/24.
//

import UIKit
import TwitterSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterSignIn.sharedInstance.handleUrl(url)
        return true
    }


}

