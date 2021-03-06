//
//  AppDelegate.swift
//  Stique
//
//  Created by Nima Sepehr on 3/15/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import UserNotifications

enum AppDefaultKeys: String {
    case ID = "UID"
}

let UID = arc4random()
var appEnteredForegroundCount = 0
var appEnteredShoppingCart = 0



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Appirater.setAppId("1218692957")
        Appirater.setDaysUntilPrompt(-1)
        Appirater.setUsesUntilPrompt(1)
        Appirater.setSignificantEventsUntilPrompt(1)
        Appirater.setTimeBeforeReminding(1)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
        Appirater.setCustomAlertTitle("We're in Beta mode and your feedback can help us greatly")
        Appirater.setCustomAlertMessage("Please consider rating us!")
        
        // Testing UID generator
        print("In Application launch... My UID is \(UID)")
        if 0 == UserDefaults.standard.integer(forKey: AppDefaultKeys.ID.rawValue) {
            // This means we don't have a UID set for this application
            //   So we want to save the UID for later retriving
            UserDefaults.standard.set(UID, forKey: AppDefaultKeys.ID.rawValue)
        }
        
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if (error != nil) {
                print("Failed to get authorization for Notification")
                return
            }
            if (granted) {
                print("Cool the user has granted notification to the application")
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // We're creating a notification for user to return to app after a long time
        StiqueNotification().createNotification(notificationCenter: notificationCenter)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //Appirater.userDidSignificantEvent(true)
        Appirater.appEnteredForeground(true)
        appEnteredForegroundCount += 1
        if appEnteredForegroundCount == 10 {
            Appirater.forceShowPrompt(false)
        }
        
        // We want to delete reminder notifications as the user has opened the application
        StiqueNotification().removePendingReminderNotification(notificationCenter: notificationCenter)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

class StiqueNotification {
    
    // This class will create the notification for the application
    private let Category = "REMINDER"
    private let Request  = "ComeAgain"
    private enum Actions: String {
        case dismiss = "DISMISS"
        case openApp = "OPENAPP"
    }
    
    func createNotification(notificationCenter center: UNUserNotificationCenter) {
        print("Creating notification")
        
        // Create actions and categories and apply to the notification center
        let actions  = getActions()
        let category = getCategory(actions)
        center.setNotificationCategories([category])
        
        // Create the content and trigger for the notification
        let content  = getContent()
        let trigger  = getTrigger()
        let request  = UNNotificationRequest(identifier: Request,
                                             content: content,
                                             trigger: trigger)
        
        // Add the notification with created request
        center.add(request) { (error: Error?) in
            if let theError = error {
                print("There was an error in adding the request")
                print(theError.localizedDescription)
            }
        }
    }
    
    func removePendingReminderNotification(notificationCenter center: UNUserNotificationCenter) {
        print("Removing \(Request) notification")
        center.removePendingNotificationRequests(withIdentifiers: [Request])
    }
    
    // Creates a category for the notification 
    // Categories will help identify the type of actions to be sent for particular notification
    private func getCategory(_ actions: [UNNotificationAction]) -> UNNotificationCategory {
        let category = UNNotificationCategory(identifier: Category,
                                              actions: actions,
                                              intentIdentifiers: [],
                                              options: .customDismissAction)
        return category
    }
    
    private func getActions() -> [UNNotificationAction] {
         let dismissAction = UNNotificationAction(identifier: Actions.dismiss.rawValue,
                                           title: "Ignore",
                                           options:.init(rawValue: 0))
        let openAction = UNNotificationAction(identifier: Actions.openApp.rawValue,
                                              title: "Open",
                                              options: .foreground)
        
        return [dismissAction, openAction]
    }
    
    private func getContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "We've missed you!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Come oonnnn... stique to it", arguments: nil)
        content.categoryIdentifier = Category
        content.sound = UNNotificationSound.default()
        
        return content
        
    }
    
    private func getTrigger() -> UNNotificationTrigger {
        // We're setting a popup to show up once after the set interval
        let timeInterval = TimeInterval(60*60*24) // 1-day
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        return trigger
    }
}











extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIView {
    var marginTop:CGFloat {
        set {
            var y:CGFloat = newValue
            if let subviews = superview?.subviews {
                var prevView:UIView?
                for view:UIView in subviews {
                    if view == self {
                        break
                    }
                    prevView = view
                }
                if let prevView = prevView {
                    y += prevView.frame.origin.y + prevView.frame.height
                }
            }
            frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
        }
        get {
            return 0.0
        }
    }
    var marginTopAbsolute:CGFloat {
        set {
            let y:CGFloat = newValue
            frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
        }
        get {
            return 0.0
        }
    }
    var marginBottom:CGFloat {
        set {
            if let _superview = superview {
                var y:CGFloat = _superview.frame.height - newValue - frame.height
                if let subviews = superview?.subviews {
                    var nextView:UIView?
                    var shouldBreakOnNext = false
                    for view:UIView in subviews {
                        if shouldBreakOnNext {
                            nextView = view
                            break
                        }
                        if view == self {
                            shouldBreakOnNext = true
                        }
                    }
                    if let nextView = nextView {
                        y = nextView.frame.origin.y - newValue
                    }
                }
                frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginBottomAbsolute:CGFloat {
        set {
            if let _superview = superview {
                let y:CGFloat = _superview.frame.height - newValue - frame.height
                frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginLeftAbsolute:CGFloat {
        set {
            if let _superview = superview {
                frame = CGRect(x: newValue, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    
    var marginRightAbsolute:CGFloat {
        set {
            if let _superview = superview {
                let x:CGFloat = _superview.frame.width - newValue - frame.width
                frame = CGRect(x: x, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginLeft:CGFloat {
        set {
            var x:CGFloat = newValue
            if let subviews = superview?.subviews {
                var prevView:UIView?
                for view:UIView in subviews {
                    if view == self {
                        break
                    }
                    prevView = view
                }
                if let prevView = prevView {
                    x += prevView.frame.origin.x + prevView.frame.width
                }
            }
            frame = CGRect(x: x, y: frame.origin.y, width: frame.width, height: frame.height)
        }
        get {
            return 0.0
        }
    }
    var widthPercent:CGFloat {
        set {
            if let superview = superview {
                let width = superview.frame.width * newValue / 100
                let x = (superview.frame.width - width) / 2
                frame = CGRect(x: x, y: frame.origin.y, width: width, height: frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var heightPercent:CGFloat {
        set {
            if let superview = superview {
                let height = superview.frame.height * newValue / 100
                let y = (superview.frame.height - height) / 2
                frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: height)
            }
        }
        get {
            return 0.0
        }
    }
    var width:CGFloat {
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.height)
        }
        get {
            return 0.0
        }
    }
    var height:CGFloat {
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: newValue)
        }
        get {
            return 0.0
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
}




/*
 Keeping for reference
import UIKit
import FontAwesome_swift
import Crashlytics
import AVFoundation

struct Globals {
    static var landscape = false
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // View controllers to be shown on the tab bar
    let myVC1 = MainViewController()
    let myVC2 = UserPlaylistController()
    let myVC3 = MasterPlaylistController()
    let myVC4 = FilterController()
    let myVC5 = ShoppingController()
    
    let tabBarController = TabBarController()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.statusBarHidden = false
        application.statusBarStyle  = .LightContent

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        self.window?.tintColor = UIColor(netHex: 0x013e38)
        
        // Define the root of the app to be the tab bar
        self.window?.rootViewController = tabBarController
        
        window!.makeKeyAndVisible()

        
        // Override point for customization after application launch.
        return true
    }
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        /*
        if let currentVC = getCurrentViewController(self.window?.rootViewController) {
            print(NSStringFromClass(currentVC.classForCoder))
            //VideoVC is the name of your class that should support landscape
            if NSStringFromClass(currentVC.classForCoder) == "AVFullScreenViewController"
             || NSStringFromClass(currentVC.classForCoder) == "Stique.FlashCardController" {
                Globals.landscape = true
                let value = UIInterfaceOrientation.LandscapeLeft.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                return UIInterfaceOrientationMask.All
            }
        }
        */
        /*
        if Globals.landscape {
            Globals.landscape = false
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
        */
 
        //return UIInterfaceOrientationMask.Portrait
        return UIInterfaceOrientationMask.All
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



extension UIView {
    var marginTop:CGFloat {
        set {
            var y:CGFloat = newValue
            if let subviews = superview?.subviews {
                var prevView:UIView?
                for view:UIView in subviews {
                    if view == self {
                        break
                    }
                    prevView = view
                }
                if let prevView = prevView {
                    y += prevView.frame.origin.y + prevView.frame.height
                }
            }
            frame = CGRectMake(frame.origin.x, y, frame.width, frame.height)
        }
        get {
            return 0.0
        }
    }
    var marginTopAbsolute:CGFloat {
        set {
            let y:CGFloat = newValue
            frame = CGRectMake(frame.origin.x, y, frame.width, frame.height)
        }
        get {
            return 0.0
        }
    }
    var marginBottom:CGFloat {
        set {
            if let _superview = superview {
                var y:CGFloat = _superview.frame.height - newValue - frame.height
                if let subviews = superview?.subviews {
                    var nextView:UIView?
                    var shouldBreakOnNext = false
                    for view:UIView in subviews {
                        if shouldBreakOnNext {
                            nextView = view
                            break
                        }
                        if view == self {
                            shouldBreakOnNext = true
                        }
                    }
                    if let nextView = nextView {
                        y = nextView.frame.origin.y - newValue
                    }
                }
                frame = CGRectMake(frame.origin.x, y, frame.width, frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginBottomAbsolute:CGFloat {
        set {
            if let _superview = superview {
                let y:CGFloat = _superview.frame.height - newValue - frame.height
                frame = CGRectMake(frame.origin.x, y, frame.width, frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginLeftAbsolute:CGFloat {
        set {
            if let _superview = superview {
                frame = CGRectMake(newValue, frame.origin.y, frame.width, frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    
    var marginRightAbsolute:CGFloat {
        set {
            if let _superview = superview {
                let x:CGFloat = _superview.frame.width - newValue - frame.width
                frame = CGRectMake(x, frame.origin.y, frame.width, frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var marginLeft:CGFloat {
        set {
            var x:CGFloat = newValue
            if let subviews = superview?.subviews {
                var prevView:UIView?
                for view:UIView in subviews {
                    if view == self {
                        break
                    }
                    prevView = view
                }
                if let prevView = prevView {
                    x += prevView.frame.origin.x + prevView.frame.width
                }
            }
            frame = CGRectMake(x, frame.origin.y, frame.width, frame.height)
        }
        get {
            return 0.0
        }
    }
    var widthPercent:CGFloat {
        set {
            if let superview = superview {
                let width = superview.frame.width * newValue / 100
                let x = (superview.frame.width - width) / 2
                frame = CGRectMake(x, frame.origin.y, width, frame.height)
            }
        }
        get {
            return 0.0
        }
    }
    var heightPercent:CGFloat {
        set {
            if let superview = superview {
                let height = superview.frame.height * newValue / 100
                let y = (superview.frame.height - height) / 2
                frame = CGRectMake(frame.origin.x, y, frame.width, height)
            }
        }
        get {
            return 0.0
        }
    }
    var width:CGFloat {
        set {
            frame = CGRectMake(frame.origin.x, frame.origin.y, newValue, frame.height)
        }
        get {
            return 0.0
        }
    }
    var height:CGFloat {
        set {
            frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, newValue)
        }
        get {
            return 0.0
        }
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.Portrait, .Landscape]
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
*/
