//
//  AppDelegate.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/15/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Stripe
import FontAwesome_swift
import Fabric
import Crashlytics
import AVFoundation

struct Globals {
    static var landscape = false
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func page(className: UITableViewController.Type) -> UIViewController {
        let grouped = className.classForCoder() == PracticeController.classForCoder() || className.classForCoder() == FilterController.classForCoder()
        let mainViewController = grouped ? className.init(style: UITableViewStyle.Grouped) : className.init()
        let navController = UINavigationController(rootViewController: mainViewController)
        navController.navigationBar.translucent = false
        //        let leftViewController = LeftPanelController()
        let leftViewController = LeftViewController(style: UITableViewStyle.Grouped)
        let rightViewController = UIViewController()
        rightViewController.view.backgroundColor = UIColor.whiteColor()
        
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.removeRightGestures()
        
        
//        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor(netHex:0x013e38)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIApplication.sharedApplication().statusBarHidden = false
        

        return slideMenuController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)

        Fabric.with([STPAPIClient.self, Crashlytics.self])

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
//        window!.rootViewController = slideMenuController
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        Stripe.setDefaultPublishableKey("pk_test_gudzcwgFyNwQqGL6R2u4346G")
        self.window?.tintColor = UIColor(netHex: 0x013e38)
        
        //        UIButton.appearance().font = UIFont.systemFontOfSize(11)
//        window!.tintColor = UIColor(netHex: 0x34495f)
        
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.translucent = false
        let myVC1 = page(MainViewController)
        let myVC2 = page(UserPlaylistController)
        let myVC3 = page(PracticeController)
        let myVC4 = page(FilterController)
        let myVC5 = page(ShoppingController)

        let controllers = [myVC3, myVC2, myVC1, myVC4, myVC5]
        tabBarController.viewControllers = controllers
        

        window?.rootViewController = tabBarController
        myVC1.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "page1"),
            tag: 1)
        myVC2.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.fontAwesomeIconWithName(.ListUL, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)),
            tag: 1)
        myVC3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.fontAwesomeIconWithName(.Book, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)),
            tag: 1)
        myVC4.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.fontAwesomeIconWithName(.Filter, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)),
            tag: 1)
        myVC5.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.fontAwesomeIconWithName(.ShoppingCart, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)),
            tag: 1)
        myVC1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC4.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC5.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        tabBarController.selectedIndex = 2
        
//        myVC2.tabBarItem = UITabBarItem(
//            title: "Pizza",
//            image: secondImage,
//            tag:2)
        Fabric.with([STPAPIClient.self, Crashlytics.self])

        // Override point for customization after application launch.
        return true
    }
    
//    func application (application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        print(self.window?.rootViewController)
//        return Globals.landscape ? UIInterfaceOrientationMask.AllButUpsideDown : UIInterfaceOrientationMask.Portrait
//    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let currentVC = getCurrentViewController(self.window?.rootViewController) {
            //VideoVC is the name of your class that should support landscape
            if NSStringFromClass(currentVC.classForCoder) == "AVFullScreenViewController" {
                Globals.landscape = true
                let value = UIInterfaceOrientation.LandscapeLeft.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
                return UIInterfaceOrientationMask.All
            }
        }
        if Globals.landscape {
            Globals.landscape = false
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
        return UIInterfaceOrientationMask.Portrait
    }
    
    func getCurrentViewController(viewController:UIViewController?)-> UIViewController?{
        
        if let slideMenuController = viewController as? SlideMenuController{
            
            return getCurrentViewController(slideMenuController.mainViewController)
        }
        if let tabBarController = viewController as? UITabBarController{
            
            return getCurrentViewController(tabBarController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController{
            return getCurrentViewController(navigationController.visibleViewController)
        }
        
        if let viewController = viewController?.presentedViewController {
            
            return getCurrentViewController(viewController)
            
        }else{
            
            return viewController
        }
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

