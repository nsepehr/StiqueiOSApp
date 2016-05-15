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
                "items":[["name":"Watched"],["name":"Purchased"],["name":"Top Rating"]]
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
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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