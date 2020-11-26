//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    
    var prevState = UIApplication.shared.applicationState
    var prevStateString: String {
        switch prevState {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        @unknown default:
            return ""
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = rootAssembly.presentationAssembly.entryPoint()
        self.window?.makeKeyAndVisible()
        
        let userDefaults = UserDefaults.standard
        let theme = userDefaults.string(forKey: "Theme")

        switch theme {
        case "classic":
            Theme.current = ClassicTheme()
        case "day":
            Theme.current = DayTheme()
        case "night":
            Theme.current = NightTheme()
        default:
            Theme.current = ClassicTheme()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
