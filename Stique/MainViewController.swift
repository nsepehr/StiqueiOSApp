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
    
    let dataController = DataController()
    var tableData = [[String: AnyObject]]()
    var searchController = UISearchController()
    var filteredTableData = [[String: AnyObject]]()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTableData.count
        }
        
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func loadTableData() {
        tableData = dataController.getMainViewData()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let vc = VocabularyViewController()
        
        if searchController.active && searchController.searchBar.text != "" {
            vc.item = filteredTableData[indexPath.row]
        } else {
            vc.item = tableData[indexPath.row]
        }

        vc.mainController = self
        // Dismiss the search bar if it's active
        if searchController.active {
            searchController.dismissViewControllerAnimated(true, completion: {
                self.navigationController?.pushViewController(vc, animated: true)
                self.searchController.searchBar.text = ""
            })
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myItem = [String: AnyObject]()
        
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as! SimpleCellView!
        if cell == nil {
            cell = SimpleCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        
        if searchController.active && searchController.searchBar.text != "" {
            myItem = filteredTableData[indexPath.row]
        } else {
            myItem = tableData[indexPath.row]
        }

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
        var vocabulary: StiqueData!
        if (self.isUserSearching()) {
            vocabulary = self.filteredTableData[actionSheetIndexPath.row]
        } else {
            vocabulary = self.tableData[actionSheetIndexPath.row]
        }
        if buttonIndex == ActionSheetButtons.AddToMasterStudy.rawValue {
            addToMaster(vocabulary)
        } else if buttonIndex == ActionSheetButtons.AddToUserPlaylist.rawValue {
            addToPlaylist(vocabulary)
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
        // Display the search bar & activate the keyboard for it
        self.searchController.searchBar.becomeFirstResponder()
        self.searchController.active = true
    }
    
    func addToPlaylist(vocabulary: StiqueData) {
        let _self = self
        let playlists = dataController.getPlaylistData()
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Which playlist", message: "Which playlist to add to?", preferredStyle: .ActionSheet)
            for playlist in playlists {
                let playlistName = (playlist["name"] as? String)!
                alert.addAction(UIAlertAction(title: playlistName, style: .Default, handler: {(alert: UIAlertAction) in
                    print("Adding playlist with name: \(playlistName) ")
                    _self.dataController.addToUserPlaylist(vocabulary, playlist: playlistName)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
    
            // Nima: Below was for before
            //let actionSheet = UIActionSheet(title: "Which Playlist To Add to?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            /*
            for myItem in playlists {
                let item = (myItem["name"] as? String)!
                actionSheet.addButtonWithTitle(item)
            }
            actionSheet.showInView(self.view)
            */
        }
    }
    
    func addToMaster(vocabulary: StiqueData) {
        self.dataController.addToMasterPlaylistData(vocabulary)
        let alert = UIAlertController(title: "Master Study", message: "Added to Master Study.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTableData = self.tableData.filter { row in
            return row["word"] != nil && (row["word"] as! String).lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func isUserSearching() -> Bool {
        if (searchController.active && searchController.searchBar.text != "") {
            return true
        }
        return false
    }
    
    // MARK: MAIL methods & Delegate
    
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
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
