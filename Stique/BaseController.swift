//
//  BaseController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class BaseController: UITableViewController, UIActionSheetDelegate {
    
    var TableData = [[String: AnyObject]]()
    var FilteredTableData = [[String: AnyObject]]()
    var searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(title: "MY STASH", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseController.rightButtonPressed))
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseController.leftButtonPressed))
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        leftButton.setTitleTextAttributes(attributes, forState: .Normal)
        leftButton.title = String.fontAwesomeIconWithName(.Bars)
        let attributesRight = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        rightButton.setTitleTextAttributes(attributesRight, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Search)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = nil//rightButton
        view.backgroundColor = UIColor.whiteColor()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.title = "Stique"
    }
    
    func leftButtonPressed() {
        slideMenuController()?.openLeft()
    }
    
    func rightButtonPressed() {
        //        let vc = RightPanelController()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return FilteredTableData.count
        }
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        FilteredTableData = TableData.filter { row in
            return row["word"] != nil && (row["word"] as! String).lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
}

extension BaseController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}