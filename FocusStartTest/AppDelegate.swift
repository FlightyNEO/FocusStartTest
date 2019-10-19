//
//  AppDelegate.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        writeCarsDictionary()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

extension AppDelegate {
    
    func writeCarsDictionary() {
        
        if let _ = try? DataManager.fetchCars() {
            #if DEBUG
            print("Fetched cars")
            #endif
        } else {
            #if DEBUG
            print("Create new cars dictionary")
            #endif
            try? DataManager.writeCarsDictionary()
        }
        
    }
    
}
