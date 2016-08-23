//
//  AppDelegate.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/11/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconManager:ESTBeaconManager!
    var beaconRegion:CLBeaconRegion!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Hide status bar all views
        application.statusBarHidden = true
        
        // Parse
        Parse.enableLocalDatastore()
        User.registerSubclass()
        Beacon.registerSubclass()
        TimeRecording.registerSubclass()
        CompanyOfficalHour.registerSubclass()
        Parse.setApplicationId("4OnWb9XZC1jm5FpuH8J6JTaH2Gq1obJvudbE4aba", clientKey:"SbxRQuDpfoT0pqWzcYHOuLV5uBnlpYIDvUQMTQg2")
        //PFUser.logOut()
        // Mark: Estimote
        ESTConfig.setupAppID("etrs", andAppToken: "7330407b28a2d07984cf228f352cf048")
        // Request authorizartion from user
        beaconManager = ESTBeaconManager()
        if ((beaconManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
            beaconManager?.requestAlwaysAuthorization()
        }
        
        // MAKR: Check permission for notification
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound],
                    categories: nil
                )
            )
        }
        
        //MARK: Setting all navigation bars
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor.MKColor.Blue
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBarAppearace.titleTextAttributes = titleDict
        
        // MARK: Check language
        // Check language of application
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.stringForKey("Language"){
            //Exist setting for language
        } else {
            //First time run app
            defaults.setObject("en", forKey: "Language")
        }
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
    
    // MARK: Another Methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = ""
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        language = "vi"
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}