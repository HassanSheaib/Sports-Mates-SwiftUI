//
//  SportMatesApp.swift
//  SportMates
//
//  Created by HHS on 18/09/2022.
//

import SwiftUI
import FirebaseCore
import Firebase
import FBSDKCoreKit



class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FBSDKCoreKit.ApplicationDelegate.shared.application(
          application,
          didFinishLaunchingWithOptions: launchOptions
      )
    FirebaseApp.configure()

    return true
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("\(#function)")
      Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print("\(#function)")
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      print("\(#function)")
      if Auth.auth().canHandle(url) {
        return true
      }
      return false
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate{
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for urlContext in URLContexts {
          let url = urlContext.url
          Auth.auth().canHandle(url)
      }
      // URL not auth related; it should be handled separately.
    }
    
}


@main
struct SportMatesApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
