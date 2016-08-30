//
//  AppDelegate.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-01.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Tell Parse to convert any "Post" PFObjects to "Post" objects
        Post.registerSubclass()

        // Initialize Parse
        Parse.setApplicationId("PnsHfng7VD1VsN2hNwzpp8VqaNVNLLcoy4Xdiryp",
                               clientKey: "1EdHWcLFrs1NmU6jk7ckV0l6W6ocNgblw6j8LTf3")
        
        let user     = PFUser()
        let username = "heather"
        let password = "test"
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock{ (success, error) in
            if success {
                print("Successfully signed up user")
            } else {
                PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) in
                    if let user = user {
                        print("Successfully logged in \(user)")
                    }
                })
            }
        }
        
        
//        // Testing SDK Connection
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if success {
//                print("Object has been saved.")
//            }
//        }

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

