//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage

class UserPlaylistSingleController: BaseController {
    
    var playlist = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        
        
        title = playlist
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlist = userDefaults.stringForKey(playlist) {
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    TableData = jsonData
                }
            } catch _ {
                // error handling
                print("error2")
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let myItem = TableData[indexPath.row]
        cell?.textLabel?.text = myItem["word"] as? String
//        let type = myItem["type"] as? Int
        
//        cell?.icon.image = UIImage.fontAwesomeIconWithName(type == 1 ? .PlayCircle : .Cog, textColor: UIColor.blackColor(), size: CGSizeMake(50, 50))
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        indexPath2 = indexPath
//        if type == 1 {
//            let vc = FlashCardController()
//            vc.item = TableData[indexPath.row]
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
            let vc = VocabularyViewController()
            vc.item = TableData[indexPath.row]
            //vc.mainController = self
            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            do {
                TableData.removeAtIndex(indexPath.row)
                let jsonData2 = try NSJSONSerialization.dataWithJSONObject(TableData, options: NSJSONWritingOptions.PrettyPrinted)
                userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: playlist)
                userDefaults.synchronize()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            } catch _ {}
        }
    }

}