//
//  PlaylistController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit


class MasterPlaylistDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataController = DataController()
    var tableData = [StiqueData]()
    
    // UI Oulet Object
    @IBOutlet weak var tableView: UITableView!
    
    // UI Action Object
    @IBAction func backPressed(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do the rest of the initialization
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setting the correct orientation for this view
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        // Load data
        loadData()
    }
    
    func loadData() {
        tableData = dataController.getMasterPlaylistData()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kLCellIdentifier = "masterStudyDetailCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kLCellIdentifier) as UITableViewCell!
        
        let myItem = tableData[indexPath.row]
        cell?.textLabel?.text = myItem["word"] as? String
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFlashcardView" {
            let vc = segue.destination as! FlashCardController
            vc.items = tableData
        }
    }
}

