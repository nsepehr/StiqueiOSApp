//
//  ShoppingController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class ShoppingController: UIViewController {
    
    // UI Outlet Object
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.alpha = 0.5
    }
}