//
//  MasterStudyTableViewController.swift
//  Stique
//
//  Created by Nima Sepehr on 12/3/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class MasterStudyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the tableview background image
        let tempImgView = UIImageView(image: UIImage(named: "Background"))
        tempImgView.alpha = 0.5
        tempImgView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImgView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.whiteColor()
        //header.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        //header.textLabel?.frame = header.frame
        //header.textLabel?.textAlignment = .Center
    }
}
