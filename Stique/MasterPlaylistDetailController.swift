//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class MasterPlaylistDetailController: UITableViewController {
    
    let dataController = DataController()
    var tableData = [[String: AnyObject]]()
    var footerView = UIView()
    var vc = FlashCardController()
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        footerView.hidden = tableData.count == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        title = "Master Practice"
        
        loadData()
    }
    
    func loadData() {
        tableData = dataController.getMasterPlaylistData()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let myItem = tableData[indexPath.row]
        cell?.textLabel?.text = myItem["word"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        vc = FlashCardController()
        vc.item = tableData[indexPath.row]
        //vc.mainController = self // Nima: Will have to remove for now
        vc.nav = navigationController!
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.tableData = dataController.removeMasterPlaylistData(self.tableData, index: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.whiteColor()
        
        
        let viewBtn = UIButton()
        viewBtn.setTitle("Start", forState: .Normal)
        viewBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        viewBtn.addTarget(self, action: #selector(startFunc), forControlEvents: UIControlEvents.TouchUpInside)
        if (self.tableData.count > 0 ) {
            footerView.addSubview(viewBtn)
        }
        
        viewBtn.widthPercent = 100
        viewBtn.height = 40
        viewBtn.marginTop   = 0
        
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func startFunc() {
        //indexPath2 = NSIndexPath(forRow: 0, inSection: 0) // Nima: I don't think we need this
        let vc = FlashCardController()
        vc.item = self.tableData[0]
        //vc.nav = navigationController! // Nima: Why do we need a navigation controller there?
        //vc.mainController = self // Nima: will have to remove for now
        self.presentViewController(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }

}

/* Keeping for reference
 if goNext {
 goNext = false
 //            tableView.reloadData()
 let vc = FlashCardController()
 vc.nav = navigationController!
 indexPath2 = NSIndexPath(forRow: indexPath2.row + 1, inSection: indexPath2.section)
 if indexPath2.row >= TableData.count {
 indexPath2 = NSIndexPath(forRow: 0, inSection: 0)
 }
 footerView.hidden = tableData.count == 0
 if tableData.count == 0 {
 return
 }
 vc.item = TableData[indexPath2.row]
 //vc.mainController = self // Nima: will have to remove for now
 self.presentViewController(vc, animated: true, completion: nil)
 //            navigationController?.pushViewController(vc, animated: false)
 } else {
 loadData()
 }
 */