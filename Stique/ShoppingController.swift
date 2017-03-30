//
//  ShoppingController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class ShoppingController: UIViewController {
    
    // UI Outlet Object
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.alpha = 0.75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appEnteredShoppingCart += 1
        if appEnteredShoppingCart == 1 {
            // Increment the counter for rating popup uses
            Appirater.userDidSignificantEvent(true)
        }
    }
}
