//
//  PlaylistController.swift
//  Stique
//
//  Created by Nima Sepehr on 12/4/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class PlaylistController: UITableViewController {
    
    let dataController = DataController()
    var tableData = [StiqueData]()
    
    // UI Outlet Object
    @IBOutlet weak var cellLabel: UILabel!
    
    // UI Action Object
    @IBAction func addPressed(_ sender: AnyObject) {
        createNewPlaylist()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = dataController.getPlaylistData()
        
        // Setting the tableview background image
        let tempImgView = UIImageView(image: UIImage(named: "Background"))
        tempImgView.alpha = 0.75
        tempImgView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImgView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kLCellIdentifier = "playlistCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kLCellIdentifier) as! PlaylistTableViewCell
        
        let myItem = tableData[indexPath.row]
        cell.playlistLabel.text =  myItem["name"] as? String
        
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
        return "Your Playlists"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            dataController.removePlaylistData(self.tableData, index: indexPath.row)
            self.tableData = dataController.getPlaylistData()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    func createNewPlaylist() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Playlist", message: "Please enter a playlist name:", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){ action -> Void in
            // Put your code here
            })
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        let _self = self
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if (textField.text != "") {
                print("Adding new playlist " + textField.text!)
                _self.dataController.addToPlaylistData([["name": textField.text as! AnyObject]])
                _self.tableData = _self.dataController.getPlaylistData()
                _self.tableView.reloadData()
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath: IndexPath? = tableView.indexPathForSelectedRow
        let playlistName: String = tableData[indexPath!.row]["name"] as! String
        let vc = segue.destination as! PlaylistDetailController
        vc.playlist = playlistName
    }
    
        
}

