//
//  ShoppingController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class ShoppingController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shopping"
        
        tableView.separatorColor = UIColor(netHex: 0x01c0ad)
        tableView.backgroundColor = UIColor(netHex: 0x01c0ad)
        
        let type = UILabel()
        type.text = "How to earn free credit?"
        type.font = UIFont.systemFontOfSize(16)
        type.textAlignment = NSTextAlignment.Center
//        view.addSubview(type)

        type.widthPercent = 100
        type.marginTopAbsolute = view.bounds.height / 2.0
        type.height = 50
        
        let money1 = UIButton()
//        money1.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        money1.setImage(UIImage(named: "1credit"), forState: .Normal)

        view.addSubview(money1)
        
        money1.widthPercent = 40
        money1.marginTopAbsolute = 75
        money1.marginRightAbsolute = 60
//        money1.height = 50
        
        let money2 = UIButton()
        money2.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        money2.setImage(UIImage(named: "2credit"), forState: .Normal)
        view.addSubview(money2)
        
        money2.widthPercent = 40
        money2.marginTopAbsolute = 75
        money2.marginLeftAbsolute = 60
//        money2.height = 50
        
        let money3 = UIButton()
        money3.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        money3.setImage(UIImage(named: "3credit"), forState: .Normal)
        view.addSubview(money3)
        
        money3.widthPercent = 40
        money3.marginTop = 75
        money3.marginLeftAbsolute = 60
//        money3.height = 50
        
        let money4 = UIButton()
        money4.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        money4.setImage(UIImage(named: "4credit"), forState: .Normal)
        view.addSubview(money4)
        
        money4.widthPercent = 40
        money4.marginTop = 75
        money4.marginLeftAbsolute = 60
//        money4.height = 50
    }
}