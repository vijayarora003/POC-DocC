//
//  AppDelegate.swift
//  Assignment
//
//  Created by Vijay Arora on 20-10-2023.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

/// The Application Delegate is the class that receives application-level messages, including the ``application(_:didFinishLaunchingWithOptions:)`` message most commonly used to initiate the creation of other views.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Tells the delegate that the launch process is almost done and the app is almost ready to run.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see `UIApplication.LaunchOptionsKey`.
    /// - Returns: false if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
    /// - Discussion:
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "ic_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
        return true
    }

    // MARK: UISceneSession Lifecycle
    /// Retrieves the configuration data for UIKit to use when creating a new scene.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - connectingSceneSession: The session object associated with the scene. This object contains the initial configuration data loaded from the app’s `Info.plist` file, if any.
    ///   - options: System-specific options for configuring the scene.
    /// - Returns: The configuration object containing the information needed to create the scene.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    ///  Tells the delegate that the user closed one or more of the app’s scenes from the app switcher.
    ///   - Parameters:
    ///     - application: The singleton app object.
    ///     - sceneSessions: The session objects associated with the discarded scenes.
    ///
    ///   When the user removes a scene from the app switcher, UIKit calls this method before discarding the scene’s associated session object altogether. (UIKit also calls this method to discard scenes that it can no longer display.) If your app isn’t running, UIKit calls this method the next time your app launches.
    ///
    ///   Use this method to update your app’s data structures and to release any resources associated with the scene. For example, you might use this method to update your app’s interface to incorporate the content associated with the scenes.
    ///
    ///   UIKit calls this method only when dismissing scenes permanently. It doesn’t call it when the system disconnects a scene to free up memory. Memory reclamation deletes the scene objects, but preserves the sessions associated with those scenes.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

