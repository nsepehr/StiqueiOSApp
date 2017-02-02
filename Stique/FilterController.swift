//
//  FilterController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

enum TableSections: Int {
    case standardizeExams = 0
    case sortings = 1
    case filters = 2
}


class FilterController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    
    // UI Outlet Object
    @IBOutlet weak var ascendingCheck: UIButton!
    @IBOutlet weak var descendingCheck: UIButton!
    @IBOutlet weak var watchedCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the tableview background image
        let tempImgView = UIImageView(image: UIImage(named: "Background"))
        tempImgView.alpha = 0.75
        tempImgView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImgView
        
        ascendingCheck.isHidden = true
        descendingCheck.isHidden = true
        watchedCheck.isHidden = true
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Below we will handle having a checkmark based on users previous selection of sorting and filters
        // Filter is easy: if there's a filer watched set in userDefaults, we checkmark the cell
        // Sorting is grouped:
        //    If the sorting is Ascending first cell index must be checkmarked
        //    else the Decending cell index (second one) should be checkmarked
        if indexPath.section == TableSections.standardizeExams.rawValue {
            // Do nothing
        } else if indexPath.section == TableSections.sortings.rawValue {
            if (indexPath.row == 0 && !userDefaults.bool(forKey: "sort")) {
                ascendingCheck.isHidden = false
                descendingCheck.isHidden = true
            } else if (indexPath.row == 1 && userDefaults.bool(forKey: "sort")) {
                ascendingCheck.isHidden = true
                ascendingCheck.isHidden = false
            }
        } else {
            if (userDefaults.bool(forKey: "watched")) {
                watchedCheck.isHidden = false
            } else {
                watchedCheck.isHidden = true
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == TableSections.sortings.rawValue) {
            if (indexPath.row == 0) {
                userDefaults.set(false, forKey: "sort")
                ascendingCheck.isHidden = false
                descendingCheck.isHidden = true
            }
            if (indexPath.row == 1) {
                userDefaults.set(true, forKey: "sort")
                ascendingCheck.isHidden = true
                descendingCheck.isHidden = false
            }
        } else if (indexPath.section == TableSections.filters.rawValue) {
            watchedCheck.isHidden = !watchedCheck.isHidden
            userDefaults.set(!userDefaults.bool(forKey: "watched"), forKey: "watched")
        }
        userDefaults.synchronize()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        //header.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        //header.textLabel?.frame = header.frame
        //header.textLabel?.textAlignment = .Center
    }
    
}
