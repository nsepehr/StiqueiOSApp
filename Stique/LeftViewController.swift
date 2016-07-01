//
//  LeftViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/11/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage
import SlideMenuControllerSwift

class LeftViewController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableData = [
            [
                "name": "Options",
                "link": "https://google.com"
            ],
            [
                "name": "About us",
                "link": "https://google.com"
            ],
            [
                "name": "Rate this app",
                "link": "https://google.com"
            ],
            [
                "name": "Share our app",
                "link": "https://google.com"
            ],
            [
                "name": "Send us feedback",
                "link": "https://google.com"
            ],
            [
                "name": "My Account",
                "link": "https://google.com"
            ],
        ]

        
        title = "Options"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        let myItem = TableData[indexPath.row]
        cell?.textLabel?.text = myItem["name"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let myItem = TableData[indexPath.row]
        let link = myItem["link"] as? String
        UIApplication.sharedApplication().openURL(NSURL(string: link!)!)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Stique"
    }

}