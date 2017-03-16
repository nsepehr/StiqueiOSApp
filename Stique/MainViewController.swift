//
//  MainViewController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import MessageUI

enum ActionSheetButtons: Int {
    case addToMasterStudy = 1
    case addToUserPlaylist = 2
    case share = 3
}

let vocabularySeque = "toVocabularyDetail"

class MainViewController: UITableViewController, UIActionSheetDelegate, MFMailComposeViewControllerDelegate {
    
    let dataController = DataController()
    var tableData = [StiqueData]()
    var searchController = UISearchController()
    var filteredTableData = [StiqueData]()
    var playlists = [StiqueData]()
    var actionSheetIndexPath: IndexPath!

    
    // UI Outlet Objects
    
    // UI Action Objects
    /* NOTE: Decision is to remove the option for cell
    @IBAction func optionsActions(_ sender: AnyObject) {
        // Below method will get the position of the button and based on that the index row
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        actionSheetIndexPath = tableView.indexPathForRow(at: buttonPosition)
        print("Selected row: \(actionSheetIndexPath.row) ")
        self.rightCellButtonPressed()
    }
    */
    
    @IBAction func menuPressed(_ sender: AnyObject) {
        leftButtonPressed()
    }
    
    /* Removed the search icon
    @IBAction func searchPressed(_ sender: AnyObject) {
        rightButtonPressed()
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar settings
        // navigationItem.title = "Stique"
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titleImageView.image = UIImage(named: "Logo")
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTableData()
        tableView.reloadData()
        // Set the correct orientation
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredTableData.count
        }
        
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myItem = [String: AnyObject]()
        
        let kLCellIdentifier = "customCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: kLCellIdentifier) as! MainTableViewCell!
        
        if searchController.isActive {
            myItem = filteredTableData[indexPath.row]
        } else {
            myItem = tableData[indexPath.row]
        }

        cell?.vocabularyLabel.text = myItem["word"] as? String
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item: StiqueData!

        if searchController.isActive {
            print("Search is active...")
            item = filteredTableData[indexPath.row]
            searchController.dismiss(animated: true, completion: {() -> Void in
                self.searchController.searchBar.text = ""
                self.searchController.isActive = false
                self.performSegue(withIdentifier: vocabularySeque, sender: item)
            })
        } else {
            item = tableData[indexPath.row]
            performSegue(withIdentifier: vocabularySeque, sender: item)
        }
    }
    
    
    func rightCellButtonPressed() {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Add to Master Study", "Add to Your Playlist", "Share")
        
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        var vocabulary: StiqueData!
        if (self.searchController.isActive) {
            vocabulary = self.filteredTableData[actionSheetIndexPath.row]
        } else {
            vocabulary = self.tableData[actionSheetIndexPath.row]
        }
        if buttonIndex == ActionSheetButtons.addToMasterStudy.rawValue {
            addToMaster(vocabulary)
        } else if buttonIndex == ActionSheetButtons.addToUserPlaylist.rawValue {
            addToPlaylist(vocabulary)
        } else if buttonIndex == ActionSheetButtons.share.rawValue {
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
        self.searchController.isActive = true
    }
    
    func addToPlaylist(_ vocabulary: StiqueData) {
        let _self = self
        let playlists = dataController.getPlaylistData()
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Which playlist", message: "Which playlist to add to?", preferredStyle: .actionSheet)
            for playlist in playlists {
                let playlistName = (playlist["name"] as? String)!
                alert.addAction(UIAlertAction(title: playlistName, style: .default, handler: {(alert: UIAlertAction) in
                    print("Adding playlist with name: \(playlistName) ")
                    _self.dataController.addToUserPlaylist(vocabulary, playlist: playlistName)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    
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
    
    func addToMaster(_ vocabulary: StiqueData) {
        self.dataController.addToMasterPlaylistData(vocabulary)
        let alert = UIAlertController(title: "Master Study", message: "Added to Master Study.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchText == "" {
            filteredTableData = self.tableData
        } else {
            filteredTableData = self.tableData.filter { row in
                return row["word"] != nil && (row["word"] as! String).lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: MAIL methods & Delegate
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
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
    
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    

    // The orientation of the view
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toVocabularyDetail" {
            let item = sender as! StiqueData
            let vc = segue.destination as! VocabularyTableViewController
            vc.item = item
        } else if segue.identifier == "toMenu" {
        }

    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
