//
//  MainViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/21/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import MessageUI
import SlideMenuControllerSwift

enum ActionSheetButtons: Int {
    case AddToMasterStudy = 1
    case AddToUserPlaylist = 2
    case Share = 3
}

class MainViewController: UITableViewController, UIActionSheetDelegate, SlideMenuControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var searchController = UISearchController()
    var tableData = [[String: AnyObject]]()
    var playlists = [[String: AnyObject]]()
    var actionSheetIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Title of the page. Appears on the navigation bar
        self.title = "Stique"
        
        // The buttons that appear on the navigation bar
        let rightButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.rightButtonPressed))
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.leftButtonPressed))
        
        leftButton.title = " "
        leftButton.image = UIImage(named: "menu")
        leftButton.tintColor = UIColor.whiteColor()
        
        rightButton.title = " "
        rightButton.image = UIImage(named: "search")
        rightButton.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        view.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(netHex: 0xdedede)
        
        navigationController?.navigationBar.barTintColor = UIColor(netHex:0x00443d)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]
        navigationController?.view.height = UIScreen.mainScreen().bounds.height + 70 // Nima: Why is this necessary?
        
        // Adding the search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // This is so that the view doesn't go under tab bar
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0); // Nima: We shouldn't harcode the 70 here
        
        self.loadTableData()
        tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* Nima: Will need to consider this when we enable the search
        if searchController.active && searchController.searchBar.text != "" {
            return FilteredTableData.count
        }
        */
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func loadTableData() {
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
                tableView.reloadData()
            }
        } catch _ {
            // error handling
            print("error couldn't load the data for table at MainViewController")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let vc = ViewController()
        
        /* Will need to update this after the search
        if searchController.active && searchController.searchBar.text != "" {
            vc.item = FilteredTableData[indexPath.row]
        } else {
            vc.item = TableData[indexPath.row]
        }
        */
        vc.item = tableData[indexPath.row]
        vc.mainController = self
        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myItem = [String: AnyObject]()
        
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as! SimpleCellView!
        if cell == nil {
            cell = SimpleCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        
        /* Will need to update this when the search feature has been implemented
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath.row]
        } else {
            myItem = TableData[indexPath.row]
        }
        */
        
        myItem = tableData[indexPath.row]

        cell?.label.text = myItem["word"] as? String
        cell.rightButton.addTarget(self, action: #selector(rightCellButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell!
    }
    
    func rightCellButtonPressed(button: UIButton) {
        actionSheetIndexPath = tableView.indexPathForCell(button.superview?.superview as! UITableViewCell)!
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Add to Master Study", "Add to Your Playlist", "Share")
        
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == ActionSheetButtons.AddToMasterStudy.rawValue {
            addToMaster()
        } else if buttonIndex == ActionSheetButtons.AddToUserPlaylist.rawValue {
            addToPlaylist()
        } else if buttonIndex == ActionSheetButtons.Share.rawValue {
            sendEmailButtonTapped()
        }
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addToUserPlaylist(i: Int) {
        // Nima: what is this i check?
        if i == 0 {
            return
        }
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var TableData2 = [[String: AnyObject]]()
        var myItem = [String: AnyObject]()
        /* Nima: will need to update once the search feature has been coded
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath2.row]
        } else {
            myItem = TableData[indexPath2.row]
        }
        */
        
        myItem = tableData[actionSheetIndexPath.row]
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
                print("error... Failed to add data to playlist")
            }
        }
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // isAddingToPlaylist = true // Nima: we shouldn't need this... just remove
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
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var TableData2 = [[String: AnyObject]]()
        var myItem = [String: AnyObject]()
        /* Nima: Will have to update this once the search feature has been enabled
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath2.row]
        } else {
            myItem = TableData[indexPath2.row]
        }
        */
        // Nima: Need to take a look into what's happening here...
        myItem = tableData[actionSheetIndexPath.row]
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
    
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
//        mailComposerVC.setToRecipients(["nurdin@gmail.com"])
        mailComposerVC.setSubject("Sharing a Video With You")
        mailComposerVC.setMessageBody("Download the Stique app on iOS to view this cool video.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
