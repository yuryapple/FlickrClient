//
//  AppDelegate.swift
//  MBPro
//
//  Created by  Yury_apple_mini on 9/29/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import FlickrKit




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window?.tintColor = UIColor.blueColor()
        
        let apiKey = "348ea26ca45d5f9d3da7fff4822a7fd1";
        let secret = "471cc96b04e60f27";
        FlickrKit.sharedFlickrKit().initializeWithAPIKey(apiKey, sharedSecret: secret)
        
        // Set global variable
        ManagerGlobalVariable.sharedInstance.itemsPerRow = 3
        
        ManagerGlobalVariable.sharedInstance.currentVisitot = GeneratorVisitorSky().genetateVisitor()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

