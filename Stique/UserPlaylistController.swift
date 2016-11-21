//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class UserPlaylistController: UITableViewController {
    
    let dataController = DataController()
    var tableData = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = nil
        
        let rightButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(rightButtonPressed))
        let attributesRight = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        rightButton.setTitleTextAttributes(attributesRight, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Plus)
        rightButton.tintColor = UIColor.whiteColor()

        navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(netHex:0x00443d)

        title = "User Playlist"
        
        tableData = dataController.getPlaylistData()

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let myItem = tableData[indexPath.row]
        cell?.textLabel?.text = myItem["name"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = UserPlaylistSingleController()
        
        let myItem = tableData[indexPath.row]
        vc.playlist = (myItem["name"] as? String)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            dataController.removePlaylistData(self.tableData, index: indexPath.row)
            self.tableData = dataController.getPlaylistData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    func rightButtonPressed() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Playlist", message: "Please enter a playlist name:", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Put your code here
        })
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        let _self = self
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                _self.dataController.addToPlaylistData([["name": textField.text as! AnyObject]])
                _self.tableData = _self.dataController.getPlaylistData()
                _self.tableView.reloadData()
            }
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }

}