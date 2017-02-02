//
//  PlaylistController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class PlaylistDetailController: UITableViewController {
    
    var playlist: String = ""
    var tableData = [StiqueData]()
    let dataController = DataController()
    
    // UI Action Object
    @IBAction func backPressed(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableData = dataController.getPlaylistDataForTitle(playlist)
        
        // Setting the tableview background image
        let tempImgView = UIImageView(image: UIImage(named: "Background"))
        tempImgView.alpha = 0.75
        tempImgView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImgView
        
        // Set navigation bar title
        navigationItem.title = playlist
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kLCellIdentifier = "playlistDetailCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kLCellIdentifier)! as UITableViewCell
        
        let myItem = tableData[indexPath.row]
        cell.textLabel?.text = myItem["word"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        //header.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        //header.textLabel?.frame = header.frame
        //header.textLabel?.textAlignment = .Center
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(playlist) Playlist"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.tableData = dataController.removePlaylistDataForTitle(self.tableData, playlist: self.playlist, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath: IndexPath? = tableView.indexPathForSelectedRow
        let myItem = tableData[indexPath!.row]
        let vc = segue.destination as! VocabularyTableViewController
        vc.item = myItem
    }
}

