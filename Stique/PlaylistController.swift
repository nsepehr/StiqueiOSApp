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

class PlaylistController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        
        TableData = [["name":"Smart Playlist","type":0],["name":"Smart Playlist","type":0],["name":"User Playlist","type":1],["name":"User Playlist","type":1],]
        
        title = "Playlists"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as! SimpleCellView!
        if cell == nil {
            cell = SimpleCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        let myItem = TableData[indexPath.row]
        cell?.label.text = myItem["name"] as? String
        let type = myItem["type"] as? Int
        
        cell?.icon.image = UIImage.fontAwesomeIconWithName(type == 1 ? .PlayCircle : .Cog, textColor: UIColor.blackColor(), size: CGSizeMake(50, 50))
        
        return cell!
    }
    
}