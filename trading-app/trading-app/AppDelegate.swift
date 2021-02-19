//
//  AppDelegate.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 18..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    class var shared : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    public class var sceneDelegate: SceneDelegate{
        return UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    }
    
    public var rootController: UIViewController {
        return AppDelegate.sceneDelegate.window!.rootViewController as! ListController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = Communicator.shared
        
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
