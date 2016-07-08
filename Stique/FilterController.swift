//
//  FilterController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage

class FilterController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        
        TableData = [
            [
                "name":"Standardized Exams",
                "items":[["name":"GER GMAT LSAT"]]
            ],[
                "name":"Alphabetical Sorting",
                "items":[["name":"Ascending"],["name":"Descending"]]
            ],[
                "name":"Filter By",
                "items":[["name":"Watched"]]
//                "items":[["name":"Watched"],["name":"Purchased"],["name":"Top Rating"]]
            ]
        ]
        
        title = "Filter Page"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)
        if cell == nil {
            if indexPath.section == 0 && indexPath.row == 0 {
                cell = ThreeImageCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
            } else {
                cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            }
        }
        let myItem = rowsInSection(indexPath.section)[indexPath.row]
        if indexPath.section == 0 && indexPath.row == 0 {
        } else {
            cell?.textLabel?.text = myItem["name"] as? String
        }
        var shouldCheck = false
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                shouldCheck = !userDefaults.boolForKey("sort")
            }
            if (indexPath.row == 1) {
                shouldCheck = userDefaults.boolForKey("sort")
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                shouldCheck = userDefaults.boolForKey("watched")
            }
            if (indexPath.row == 1) {
                shouldCheck = userDefaults.boolForKey("purchased")
            }
            if (indexPath.row == 2) {
                shouldCheck = userDefaults.boolForKey("top")
            }
        }
        
        let checked = UILabel()
        checked.tag = 1
        checked.font = UIFont.fontAwesomeOfSize(20)
        checked.text = String.fontAwesomeIconWithName(.Check)
        checked.textColor = UIColor.grayColor()
        if (shouldCheck) {
            cell?.viewWithTag(1)?.removeFromSuperview()
            cell?.addSubview(checked)
        }
        
        checked.width = 20
        checked.marginTopAbsolute = 15
        checked.marginRightAbsolute = 15
        checked.height = 20
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if (indexPath.section == 1) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.viewWithTag(1)?.removeFromSuperview()
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))?.viewWithTag(1)?.removeFromSuperview()
            if (indexPath.row == 0) {
                userDefaults.setBool(false, forKey: "sort")
            }
            if (indexPath.row == 1) {
                userDefaults.setBool(true, forKey: "sort")
            }
        }
        if (indexPath.section == 2) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))?.viewWithTag(1)?.removeFromSuperview()
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2))?.viewWithTag(1)?.removeFromSuperview()
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2))?.viewWithTag(1)?.removeFromSuperview()
            if (indexPath.row == 0) {
                userDefaults.setBool(!userDefaults.boolForKey("watched"), forKey: "watched")
            }
            if (indexPath.row == 1) {
                userDefaults.setBool(!userDefaults.boolForKey("purchased"), forKey: "purchased")
            }
            if (indexPath.row == 2) {
                userDefaults.setBool(!userDefaults.boolForKey("top"), forKey: "top")
            }
        }
        userDefaults.synchronize()
        tableView.reloadData()
    }
    
    func rowsInSection(section: Int) -> [[String:AnyObject]] {
        return (TableData[section]["items"] as! [[String:AnyObject]])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection(section).count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableData[section]["name"] as? String
    }
    
}