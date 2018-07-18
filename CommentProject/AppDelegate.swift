//
//  AppDelegate.swift
//  CommentProject
//
//  Created by 王帅 on 2018/6/25.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         self.window = UIWindow.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width:SCREEN_WIDTH, height:SCREEN_HEIGHT)))
        self.window?.makeKeyAndVisible()
       
        HQVersionUpadateManager.shareManger().checkVersion()
        
        if !HQGuideVC.hadLoaded(){
            let VC = HQGuideVC.loadWithBlock {[unowned self] (isFinish:Bool) in
                let nav:HQBaseNavC = HQBaseNavC(rootViewController:HomeVC())
                self.window?.rootViewController = nav
            }
            self.window?.rootViewController = VC//第一次进入会走这里
        }else{
            let nav:HQBaseNavC = HQBaseNavC(rootViewController:HomeVC())
            self.window?.rootViewController = nav
        }
        return true
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

