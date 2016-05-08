//
//  ShoppingController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage

class ShoppingController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        
        tableView.separatorColor = UIColor.whiteColor()
        
        let type = UILabel()
        type.text = "How to earn free credit?"
        type.font = UIFont.systemFontOfSize(16)
        type.textAlignment = NSTextAlignment.Center
        view.addSubview(type)

        type.widthPercent = 100
        type.marginTopAbsolute = view.bounds.height / 2.0
        type.height = 50
        
        let money1 = UIButton()
        money1.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        view.addSubview(money1)
        
        money1.widthPercent = 20
        money1.marginTopAbsolute = 75
        money1.marginRightAbsolute = 60
        money1.height = 50
        
        let money2 = UIButton()
        money2.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        view.addSubview(money2)
        
        money2.widthPercent = 20
        money2.marginTopAbsolute = 75
        money2.marginLeftAbsolute = 60
        money2.height = 50
        
        let money3 = UIButton()
        money3.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Money), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        view.addSubview(money3)
        
        money3.widthPercent = 20
        money3.marginTop = 75
        money3.marginLeftAbsolute = 60
        money1.height = 50
    }
}