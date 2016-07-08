//
//  PracticeController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage

class PracticeController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        TableData = [
                [
                    "name":"Master Practice",
                    "items":[["name":"Master Practice"]]
                ],[
                    "name":"Standard Practice",
                    "items":[["name":"GRE Practice"],["name":"GMAT Practice"],["name":"LSAT Practice"]]
                ]
            ]
            
            title = "Practice Page"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        let myItem = rowsInSection(indexPath.section)[indexPath.row]
        cell?.textLabel?.text = myItem["name"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = PlaylistSingleController()
        vc.type = 1
        navigationController?.pushViewController(vc, animated: true)
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