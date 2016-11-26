//
//  TabBarController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/24/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // View controllers to be shown on the tab bar
    let myVC1 = MainViewController()
    let myVC2 = UserPlaylistController()
    let myVC3 = MasterPlaylistController()
    let myVC4 = FilterController()
    let myVC5 = ShoppingController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Define the Tab Bar items
        setTabBarItems()
        let mainNav     = NavigationController(rootViewController: myVC1)
        let playlistNav = NavigationController(rootViewController: myVC2)
        let masterNav   = NavigationController(rootViewController: myVC3)
        let filterNav   = NavigationController(rootViewController: myVC4)
        let shopNav     = NavigationController(rootViewController: myVC5)
        let controllers: [UIViewController] = [masterNav, playlistNav, mainNav, filterNav, shopNav]
        self.viewControllers = controllers
        
        // Select the main view controller as the first view to be shown
        self.selectedIndex = 2
        
        // Fixes for the appearance of the tab bar to match the design
        self.tabBar.translucent = true
        self.tabBar.barTintColor = UIColor(netHex:0x013e38)
        self.tabBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabBarItems() {
        myVC1.tabBarItem = UITabBarItem(
            title: " ",
            image: UIImage(named: "home"),
            tag: 1)
        myVC2.tabBarItem = UITabBarItem(
            title: " ",
            image: UIImage(named: "playlist"),
            tag: 1)
        myVC3.tabBarItem = UITabBarItem(
            title: " ",
            image: UIImage(named: "master_study"),
            tag: 1)
        myVC4.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "filter"),
            tag: 1)
        myVC5.tabBarItem = UITabBarItem(
            title: " ",
            image: UIImage(named: "shopping_cart"),
            tag: 1)
        myVC1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC4.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        myVC5.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
