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

class PlaylistSingleController: BaseController {
    
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlist = userDefaults.stringForKey("playlist" + String(type)) {
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
        
        title = type == 0 ? "Smart Playlist" : "User Playlist"
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
        let vc = ViewController()
        vc.item = TableData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }

}