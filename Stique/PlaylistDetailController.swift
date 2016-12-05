//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class PlaylistDetailController: UITableViewController {
    
    var playlist: String = ""
    var tableData = [StiqueData]()
    let dataController = DataController()
    
    // UI Action Object
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableData = dataController.getPlaylistDataForTitle(playlist)
        
        // Setting the tableview background image
        let tempImgView = UIImageView(image: UIImage(named: "Background"))
        tempImgView.alpha = 0.5
        tempImgView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImgView
        
        // Set navigation bar title
        navigationItem.title = playlist
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "playlistDetailCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)! as UITableViewCell
        
        let myItem = tableData[indexPath.row]
        cell.textLabel?.text = myItem["word"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.whiteColor()
        //header.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        //header.textLabel?.frame = header.frame
        //header.textLabel?.textAlignment = .Center
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(playlist) Playlist"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.tableData = dataController.removePlaylistDataForTitle(self.tableData, playlist: self.playlist, index: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath? = tableView.indexPathForSelectedRow
        let myItem = tableData[indexPath!.row]
        let vc = segue.destinationViewController as! VocabularyViewController
        vc.item = myItem
    }
}

