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
    
    // UI Outlet Object
    @IBOutlet weak var ascendingCheck: UIButton!
    @IBOutlet weak var descendingCheck: UIButton!
    @IBOutlet weak var watchedCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Filter Page"
        ascendingCheck.hidden = true
        descendingCheck.hidden = true
        watchedCheck.hidden = true
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Below we will handle having a checkmark based on users previous selection of sorting and filters
        // Filter is easy: if there's a filer watched set in userDefaults, we checkmark the cell
        // Sorting is grouped:
        //    If the sorting is Ascending first cell index must be checkmarked
        //    else the Decending cell index (second one) should be checkmarked
        if indexPath.section == TableSections.StandardizeExams.rawValue {
            // Do nothing
        } else if indexPath.section == TableSections.Sortings.rawValue {
            if (indexPath.row == 0 && !userDefaults.boolForKey("sort")) {
                ascendingCheck.hidden = false
                descendingCheck.hidden = true
            } else if (indexPath.row == 1 && userDefaults.boolForKey("sort")) {
                ascendingCheck.hidden = true
                ascendingCheck.hidden = false
            }
        } else {
            if (userDefaults.boolForKey("watched")) {
                watchedCheck.hidden = false
            } else {
                watchedCheck.hidden = true
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == TableSections.Sortings.rawValue) {
            if (indexPath.row == 0) {
                userDefaults.setBool(false, forKey: "sort")
                ascendingCheck.hidden = false
                descendingCheck.hidden = true
            }
            if (indexPath.row == 1) {
                userDefaults.setBool(true, forKey: "sort")
                ascendingCheck.hidden = true
                descendingCheck.hidden = false
            }
        } else if (indexPath.section == TableSections.Filters.rawValue) {
            watchedCheck.hidden = !watchedCheck.hidden
            userDefaults.setBool(!userDefaults.boolForKey("watched"), forKey: "watched")
        }
        userDefaults.synchronize()
    }
}