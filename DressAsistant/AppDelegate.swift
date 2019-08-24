//
//  AppDelegate.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 13/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    setupGlobalUI()
    setupFirebase()
    setupFabric()
    
    return true
  }
  
  private func setupFabric() {
    Fabric.with([Crashlytics.self])
  }
  
  private func setupFirebase() {
    FirebaseApp.configure()
    configureFirestore()
  }
  
  private func configureFirestore() {
    let settings = Firestore.firestore().settings
    settings.isPersistenceEnabled = true
    settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
    Firestore.firestore().settings = settings
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if let link =  userActivity.webpageURL?.absoluteString {
      if AuthService().isSignIn(withLink: link, updateLink: true) {
        NotificationCenter.default.post(name: CustomNotificationName.userHasSigned,
                                        object: nil)
      }
      return true
    }
    
    return false
  }
  
  private func setupGlobalUI() {
    UINavigationBar.appearance().barTintColor = CustomColor.topBarColor
    UINavigationBar.appearance().tintColor = CustomColor.topBarTextColor
    
    let titleColor =  [NSAttributedString.Key.foregroundColor : CustomColor.topBarTextColor]
    UINavigationBar.appearance().titleTextAttributes = titleColor
    UIBarButtonItem.appearance().setTitleTextAttributes(titleColor, for: .normal)
    
    UIRefreshControl.appearance().tintColor = CustomColor.mainColor
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

