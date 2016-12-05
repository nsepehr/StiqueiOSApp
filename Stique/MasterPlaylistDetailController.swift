//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit


class MasterPlaylistDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataController = DataController()
    var tableData = [StiqueData]()
    
    // UI Oulet Object
    @IBOutlet weak var tableView: UITableView!
    
    // UI Action Object
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do the rest of the initialization
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Setting the correct orientation for this view
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        // Load data
        loadData()
    }
    
    func loadData() {
        tableData = dataController.getMasterPlaylistData()
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "masterStudyDetailCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as UITableViewCell!
        
        let myItem = tableData[indexPath.row]
        cell?.textLabel?.text = myItem["word"] as? String
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFlashcardView" {
            let vc = segue.destinationViewController as! FlashCardController
            vc.items = tableData
        }
    }
}

