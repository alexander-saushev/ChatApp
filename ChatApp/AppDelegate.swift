//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
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
    
    func stateLogger(currentState: UIApplication.State, methodName: String) {

//        var currentStateString = ""
//
//        switch currentState {
//        case .active:
//            currentStateString = "Active"
//        case .background:
//            currentStateString = "Background"
//        case .inactive:
//            currentStateString = "Inactive"
//        @unknown default:
//            currentStateString = ""
//        }
//
//        #if DEBUG
//        print("Called method: \(methodName)")
//
//        if prevState != currentState {
//            //print("Application moved from \(prevStateString) to \(currentStateString)")
//            self.prevState = currentState
//        }
//        else {
//            print("Application state is \(currentStateString)")
//        }
//
//        print("")
//        #endif

    }

    // Приложение не шлет уведомление о переходе в состояние Inactive, поэтому для логирования
    // этого состояния я сделал специальный метод. По умолчанию используется автоматический,
    // «более умный» вариант
    func stateLoggerWithInactiveStates(_ method: String) {
        switch method {
        case "application(_:willFinishLaunchingWithOptions:)":
            print("Application moved from 'Not running' to 'Inactive'.")
            print("")
        case "application(_:didFinishLaunchingWithOptions:)":
            print("Application state remains 'Inactive'.")
            print("")
        case "applicationDidBecomeActive(_:)":
            print("Application moved from 'Inactive' to 'Active'.")
            print("")
        case "applicationWillResignActive(_:)":
            print("Application moved from 'Active' to 'Inactive'.")
            print("")
        case "applicationDidEnterBackground(_:)":
            print("Application moved from 'Inactive' to 'Background'.")
            print("")
        case "applicationWillEnterForeground(_:)":
            print("Application moved from 'Background' to 'Inactive'.")
            print("")
        case "applicationWillTerminate(_:)":
            print("Application moved from 'Background' to 'Suspended' and then to 'Not running'.")
            print("")
        default:
            break
        }
    }
    
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        stateLogger(currentState: UIApplication.shared.applicationState, methodName: #function)
    }
}






