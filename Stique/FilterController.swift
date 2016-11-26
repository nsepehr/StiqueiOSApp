//
//  FilterController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

enum TableSections: Int {
    case StandardizeExams = 0
    case Sortings = 1
    case Filters = 2
}


class FilterController: UITableViewController {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let tableData = [
        [
            "name":"Standardized Exams",
            "items":[["name":"GER GMAT LSAT"]]
        ],[
            "name":"Alphabetical Sorting",
            "items":[["name":"Ascending"],["name":"Descending"]]
        ],[
            "name":"Filter By",
            "items":[["name":"Watched"]]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Filter Page"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier)
        if cell == nil {
            if indexPath.section == TableSections.StandardizeExams.rawValue && indexPath.row == 0 {
                cell = ThreeImageCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
            } else {
                cell = UITableViewCell(style:.Default, reuseIdentifier: kLCellIdentifier)
            }
        }
        let myItem = rowsInSection(indexPath.section)[indexPath.row]
        if indexPath.section == TableSections.StandardizeExams.rawValue && indexPath.row == 0 {
        } else {
            // Below we will handle having a checkmark based on users previous selection of sorting and filters
            // Filter is easy: if there's a filer watched set in userDefaults, we checkmark the cell
            // Sorting is grouped: 
            //    If the sorting is Ascending first cell index must be checkmarked
            //    else the Decending cell index (second one) should be checkmarked
            cell?.textLabel?.text = myItem["name"] as? String
            if (indexPath.section == TableSections.Sortings.rawValue) {
                if (indexPath.row == 0 && !userDefaults.boolForKey("sort")) {
                    cell?.accessoryType = .Checkmark
                } else if (indexPath.row == 1 && userDefaults.boolForKey("sort")) {
                    cell?.accessoryType = .Checkmark
                }
            } else if (indexPath.section == TableSections.Filters.rawValue) {
                if (userDefaults.boolForKey("watched")) {
                    cell?.accessoryType = .Checkmark
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if (indexPath.section == TableSections.Sortings.rawValue) {
            var otherCell: UITableViewCell!
            if (indexPath.row == 0) {
                otherCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: indexPath.section))
                userDefaults.setBool(false, forKey: "sort")
            }
            if (indexPath.row == 1) {
                otherCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: indexPath.section))
                userDefaults.setBool(true, forKey: "sort")
            }
            // Below will check the selected cell and uncheck the other one in the group. We only have two cells so above harcoding we can deal with
            cell.accessoryType = .Checkmark
            otherCell.accessoryType = .None
        }
        if (indexPath.section == TableSections.Filters.rawValue) {
            if (cell.accessoryType == .Checkmark) {cell.accessoryType = .None}
            else {cell.accessoryType = .Checkmark}
            userDefaults.setBool(!userDefaults.boolForKey("watched"), forKey: "watched")
        }
        userDefaults.synchronize()
    }
    
    func rowsInSection(section: Int) -> [StiqueData] {
        return (tableData[section]["items"] as! [StiqueData])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection(section).count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section]["name"] as? String
    }
    
}