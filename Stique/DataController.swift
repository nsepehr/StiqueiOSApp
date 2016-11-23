//
//  DataController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/20/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import Foundation

enum Playlists: String {
    case MasterPlaylist = "masterPlaylist"
    case UserPlaylist   = "userPlaylist"
}

// Let's define an alias for the type of object we'll use everywhere
typealias StiqueData = [String: AnyObject]


class DataController {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

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
            if let playlist = userDefaults.stringForKey(Playlists.UserPlaylist.rawValue) {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: Playlists.UserPlaylist.rawValue)
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
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: Playlists.UserPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove playlist")
        }
    }
    
    func getPlaylistData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlists = userDefaults.stringForKey(Playlists.UserPlaylist.rawValue) {
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
    
    func addToUserPlaylist(data: StiqueData, playlist: String) {
        var tableData: [StiqueData] = [data]
        var isUnique: Bool = true
        let playlistKey: String = getUserPlaylistKey(playlist)
        print("From data controller. Adding word \(data["word"]!) to playlist key " + playlistKey)
        do {
            let jsonData = getPlaylistDataForTitle(playlist)
            print("My jsonData for playlist is: ")
            print(jsonData)
            for item in jsonData {
                if item["word"] as! String == (data["word"] as! String) {
                    isUnique = false
                    break
                }
            }
            if (isUnique) {
                tableData += jsonData
                print("Inside the addToUserPlaylist and table data is: ")
                print(tableData)
                let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
                userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: playlistKey)
                userDefaults.synchronize()
            }
        } catch _ {
            print("Unable to add to user playlist")
        }
    }
    
    func getUserPlaylistKey(playlistName: String) -> String {
        let playlistKey: String = Playlists.UserPlaylist.rawValue + playlistName
        return playlistKey
    }
    
    func removePlaylistDataForTitle(data: [[String: AnyObject]], playlist: String, index: Int) -> [[String: AnyObject]] {
        let playlistKey = getUserPlaylistKey(playlist)
        var tableData = data
        let userDefaults = NSUserDefaults.standardUserDefaults()
        do {
            tableData.removeAtIndex(index)
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: playlistKey)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove data for playlist title \(playlistKey)")
        }
        
        return tableData
    }
    
    func getPlaylistDataForTitle(playlist: String) -> [StiqueData] {
        let playlistKey = getUserPlaylistKey(playlist)
        print("Getting playlist data for key: " + playlistKey)
        var tableData = [StiqueData]()
        do {
            if let _playlist = userDefaults.stringForKey(playlistKey) {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(_playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [StiqueData]
                print("jsonData for that key is: ")
                print(jsonData)
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            }
        } catch _ {
                // error handling
                print("Error... Unable to the playlist data for title: \(playlistKey)")
        }
        
        return tableData
    }
    
    func addToMasterPlaylistData(data: StiqueData) {
        
        var tableData = [data]
        do {
            if let playlist = userDefaults.stringForKey(Playlists.MasterPlaylist.rawValue) {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [StiqueData]
                if let jsonData = jsonData {
                    for item in jsonData {
                        if item["word"] as! String == (data["word"] as! String) {
                            tableData = []
                            break
                        }
                    }
                    tableData += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: Playlists.MasterPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Unable to add to master playlist")
        }
    }
    
    func removeMasterPlaylistData(data: [[String: AnyObject]], index: Int) -> [[String: AnyObject]] {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var tableData = data
        do {
            tableData.removeAtIndex(index)
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(tableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: Playlists.MasterPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove master playlist detail data")
        }
        
        return tableData
    }
    
    func getMasterPlaylistData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlist = userDefaults.stringForKey(Playlists.MasterPlaylist.rawValue) {
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            } catch _ {
                // error handling
                print("Error... Failed to get Master Playlist data")
            }
        }
        
        return tableData
    }
}
