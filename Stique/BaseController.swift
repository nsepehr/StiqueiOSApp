//
//  BaseController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class BaseController: UITableViewController, UIActionSheetDelegate, SlideMenuControllerDelegate {
    
    var TableData = [[String: AnyObject]]()
    var FilteredTableData = [[String: AnyObject]]()
    var searchController = UISearchController()
    var isAddingToPlaylist = false
    var playlists = [[String: AnyObject]]()
    var indexPath2 = NSIndexPath()
    var goNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(title: "MY STASH", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseController.rightButtonPressed))
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseController.leftButtonPressed))
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        leftButton.setTitleTextAttributes(attributes, forState: .Normal)
        leftButton.title = String.fontAwesomeIconWithName(.Bars)
        leftButton.tintColor = UIColor.whiteColor()
        let attributesRight = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        rightButton.setTitleTextAttributes(attributesRight, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Search)
        rightButton.tintColor = UIColor(netHex:0x00443d)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = nil//rightButton
        view.backgroundColor = UIColor.whiteColor()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        navigationController?.navigationBar.barTintColor = UIColor(netHex:0x00443d)
//        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as! [String: AnyObject]
        
        self.title = "Stique"
    }
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    func leftButtonPressed() {
        slideMenuController()?.openLeft()
        view.userInteractionEnabled = false
        slideMenuController()?.delegate = self
    }
    
    func leftDidClose() {
        view.userInteractionEnabled = true
    }
    
    func rightButtonPressed() {
        //        let vc = RightPanelController()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return false
//    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return FilteredTableData.count
        }
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        FilteredTableData = TableData.filter { row in
            return row["word"] != nil && (row["word"] as! String).lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    
    
    func addToUserPlaylist(i: Int) {
        if i == 0 {
            return
        }
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var TableData2 = [[String: AnyObject]]()
        var myItem = [String: AnyObject]()
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath2.row]
        } else {
            myItem = TableData[indexPath2.row]
        }
        TableData2 = [myItem]
        
        
        let myPlaylist = playlists[i-1]
        let playlistKey = (myPlaylist["name"] as? String)!
        
        do {
            if let playlist = userDefaults.stringForKey(playlistKey) {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    for item in jsonData {
                        if item["word"] as! String == myItem["word"] as! String {
                            TableData2 = []
                            break
                        }
                    }
                    TableData2 += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(TableData2, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: playlistKey)
            userDefaults.synchronize()
        } catch _ {}
    }
    
    func addToPlaylist() {
        playlists = [[String: AnyObject]]()
        let _self = self
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlists = userDefaults.stringForKey("playlists") {
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlists.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    _self.playlists = jsonData
                }
            } catch _ {
                // error handling
                print("error2")
            }
        }
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            isAddingToPlaylist = true
            let actionSheet = UIActionSheet(title: "Which Playlist To Add to?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            
            for myItem in playlists {
                let playlist = (myItem["name"] as? String)!
                actionSheet.addButtonWithTitle(playlist)
            }
            if playlists.count > 0 {
                actionSheet.showInView(self.view)
            }
        }
    }
    
    func addToMaster() {
        print("ok")
        //
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var TableData2 = [[String: AnyObject]]()
        var myItem = [String: AnyObject]()
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath2.row]
        } else {
            myItem = TableData[indexPath2.row]
        }
        TableData2 = [myItem]
        do {
            if let playlist = userDefaults.stringForKey("playlist1") {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    for item in jsonData {
                        if item["word"] as! String == myItem["word"] as! String {
                            TableData2 = []
                            break
                        }
                    }
                    TableData2 += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(TableData2, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: "playlist1")
            userDefaults.synchronize()
        } catch _ {}
        
        
        let alert = UIAlertController(title: "Master Study", message: "Added to Master Study.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func removeItem(indexPath: NSIndexPath) {let userDefaults = NSUserDefaults.standardUserDefaults()
        do {
            TableData.removeAtIndex(indexPath.row)
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(TableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: "playlist1")
            userDefaults.synchronize()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        } catch _ {}
    }
    
}

extension BaseController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}