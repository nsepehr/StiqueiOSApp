//
//  PracticeController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class MasterPlaylistController: UITableViewController {
    
    let masterList = [
        [
            "name":"Master Practice",
            "items":[["name":"Master Practice"]]
        ],[
            "name":"Standard Practice",
            "items":[["name":"GRE Practice"],["name":"GMAT Practice"],["name":"LSAT Practice"]]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem  = nil
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(netHex:0x00443d)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]
        
        title = "Master Practice"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        let myItem = rowsInSection(indexPath.section)[indexPath.row]
        cell?.textLabel?.text = myItem["name"] as? String
        // Let's make the second section unselectable for now
        if (indexPath.section > 0) {
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.userInteractionEnabled = false
            cell?.textLabel?.enabled = false
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = MasterPlaylistDetailController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rowsInSection(section: Int) -> [[String:AnyObject]] {
        return (masterList[section]["items"] as! [[String:AnyObject]])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return masterList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection(section).count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return masterList[section]["name"] as? String
    }
    
}