//
//  MainViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/21/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import MessageUI

enum ActionSheetButtons: Int {
    case AddToMasterStudy = 1
    case AddToUserPlaylist = 2
    case Share = 3
}

let vocabularySeque = "toVocabularyDetail"

class MainViewController: UITableViewController, UIActionSheetDelegate, MFMailComposeViewControllerDelegate {
    
    let dataController = DataController()
    var tableData = [StiqueData]()
    var searchController = UISearchController()
    var filteredTableData = [StiqueData]()
    var playlists = [StiqueData]()
    var actionSheetIndexPath: NSIndexPath!

    
    // UI Outlet Objects
    
    // UI Action Objects
    @IBAction func optionsActions(sender: AnyObject) {
        // Below method will get the position of the button and based on that the index row
        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        actionSheetIndexPath = tableView.indexPathForRowAtPoint(buttonPosition)
        print("Selected row: \(actionSheetIndexPath.row) ")
        self.rightCellButtonPressed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar settings
        navigationItem.title = "Stique"
        
        // The buttons that appear on the navigation bar
        let rightButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.rightButtonPressed))
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.leftButtonPressed))
        
        leftButton.title = " "
        leftButton.image = UIImage(named: "menu")
        leftButton.tintColor = UIColor.whiteColor()
        
        rightButton.title = " "
        rightButton.image = UIImage(named: "search")
        rightButton.tintColor = UIColor.whiteColor()
        
        let backButton = UIBarButtonItem()
        backButton.setBackgroundImage(UIImage(named: "Navigation Back Button"), forState: .Normal, barMetrics: .Default)
        backButton.title = " "
        
        navigationItem.backBarButtonItem = backButton
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        tableView.separatorColor = UIColor(netHex: 0xdedede)
        
        
        // Adding the search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.loadTableData()
        tableView.reloadData()
        
    }
    
    func loadTableData() {
        tableData = dataController.getMainViewData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTableData()
        tableView.reloadData()
        // Set the correct orientation
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active {
            return filteredTableData.count
        }
        
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myItem = [String: AnyObject]()
        
        let kLCellIdentifier = "customCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as! MainTableViewCell!
        
        if searchController.active {
            myItem = filteredTableData[indexPath.row]
        } else {
            myItem = tableData[indexPath.row]
        }

        cell.vocabularyLabel.text = myItem["word"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item: StiqueData!

        if searchController.active {
            print("Search is active...")
            item = filteredTableData[indexPath.row]
            self.searchController.searchBar.text = ""
            searchController.dismissViewControllerAnimated(true, completion: {() -> Void in
                self.performSegueWithIdentifier(vocabularySeque, sender: item)
            })
        } else {
            item = tableData[indexPath.row]
            performSegueWithIdentifier(vocabularySeque, sender: item)
        }
    }
    
    
    func rightCellButtonPressed() {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Add to Master Study", "Add to Your Playlist", "Share")
        
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var vocabulary: StiqueData!
        if (self.searchController.active) {
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
        /*
        slideMenuController()?.openLeft()
        view.userInteractionEnabled = false
        slideMenuController()?.delegate = self
        */
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
        if searchText == "" {
            filteredTableData = self.tableData
        } else {
            filteredTableData = self.tableData.filter { row in
                return row["word"] != nil && (row["word"] as! String).lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        
        tableView.reloadData()
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
    

    // The orientation of the view
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        //let indexPath: NSIndexPath? = tableView.indexPathForSelectedRow
        let item = sender as! StiqueData
        let vc = segue.destinationViewController as! VocabularyViewController
        vc.item = item
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
