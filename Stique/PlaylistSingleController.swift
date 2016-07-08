//
//  PlaylistController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage

class PlaylistSingleController: BaseController {
    
    var type = 0
    
    override func viewWillAppear(animated: Bool) {
        if goNext {
            goNext = false
            let vc = FlashCardController()
            indexPath2 = NSIndexPath(forRow: indexPath2.row + 1, inSection: indexPath2.section)
            if indexPath2.row >= TableData.count {
                indexPath2 = NSIndexPath(forRow: 0, inSection: 0)
            }
            if TableData.count == 0 {
                return
            }
            vc.item = TableData[indexPath2.row]
            vc.mainController = self
            navigationController?.pushViewController(vc, animated: false)
        } else {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        title = type == 0 ? "Smart Playlist" : "Master Practice"
        
        loadData()
    }
    
    func loadData() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let playlist = userDefaults.stringForKey("playlist" + String(type)) {
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    TableData = jsonData
                }
            } catch _ {
                // error handling
                print("error2")
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let myItem = TableData[indexPath.row]
        cell?.textLabel?.text = myItem["word"] as? String
//        let type = myItem["type"] as? Int
        
//        cell?.icon.image = UIImage.fontAwesomeIconWithName(type == 1 ? .PlayCircle : .Cog, textColor: UIColor.blackColor(), size: CGSizeMake(50, 50))
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        indexPath2 = indexPath
        if type == 1 {
            let vc = FlashCardController()
            vc.item = TableData[indexPath.row]
            vc.mainController = self
            navigationController?.pushViewController(vc, animated: true)
//            self.addChildViewController(vc)
//            self.view.addSubview(vc.view)
        } else {
            let vc = ViewController()
            vc.item = TableData[indexPath.row]
            vc.mainController = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            removeItem(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.whiteColor()
        
        
        let viewBtn = UIButton()
        viewBtn.setTitle("Start", forState: .Normal)
        viewBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        viewBtn.addTarget(self, action: #selector(startFunc), forControlEvents: UIControlEvents.TouchUpInside)
        if (TableData.count > 0 ) {
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
        indexPath2 = NSIndexPath(forRow: 0, inSection: 0)
        let vc = FlashCardController()
        vc.item = TableData[indexPath2.row]
        vc.mainController = self
        navigationController?.pushViewController(vc, animated: true)
    }

}