//
//  DataController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/20/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import Foundation

class DataController {

    func getMainViewData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        do {
            let path = NSBundle.mainBundle().pathForResource("words", ofType: "json")
            let data: NSData? = NSData(contentsOfFile: path!)
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [[String: AnyObject]]
            if let jsonData = jsonData {
                tableData = jsonData
                if (userDefaults.boolForKey("sort")) {
                    tableData = tableData.reverse()
                }
                if userDefaults.boolForKey("watched") {
                    var NewTableData = [[String: AnyObject]]()
                    if let watched = userDefaults.objectForKey("watched_words") as? [String] {
                        for row in tableData {
                            if watched.contains(row["word"] as! String) {
                                NewTableData += [row]
                            }
                        }
                    }
                    tableData = NewTableData
                }
            }
        } catch _ {
            // error handling
            print("error couldn't load the data for table at Data Controller class")
        }
        
        return tableData
    }
    
    func addToPlaylistData(data: [[String: AnyObject]]) {
        var tableData = data
        let userDefaults = NSUserDefaults.standardUserDefaults()
        do {
            if let playlist = userDefaults.stringForKey("playlists") {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: "playlists")
            userDefaults.synchronize()
        } catch _ {
            print("Failed to add user playlist")
        }
    }
    
    func removePlaylistData(data: [[String: AnyObject]], index: Int) {
        var tableData: [[String: AnyObject]] = data
        let userDefaults = NSUserDefaults.standardUserDefaults()
        do {
            tableData.removeAtIndex(index)
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: "playlists")
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove playlist")
        }
    }
    
    func getPlaylistData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlists = userDefaults.stringForKey("playlists") {
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlists.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            } catch _ {
                // error handling
                print("Error... Unable to get User Playlist data")
            }
        }
        
        return tableData
    }
}
