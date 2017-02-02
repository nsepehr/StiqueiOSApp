//
//  ViewController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/25/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set the color of the bar
        self.navigationBar.barTintColor = UIColor(netHex:0x00443d)
        self.navigationBar.tintColor = UIColor.white
        // Set the back button the design arrow
        let backButton = UIBarButtonItem()
        backButton.setBackgroundImage(UIImage(named: "back"), for: UIControlState(), barMetrics: .default)
        backButton.title = " "
        
        //UIBarButtonItem.setBackButtonBackgroundImage(backButton)
        
 
        // Set the title attributes
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]
        //navigationController.view.height = UIScreen.mainScreen().bounds.height + 70 // Nima: Why is this necessary?
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
