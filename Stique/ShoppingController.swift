//
//  ShoppingController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 4/9/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class ShoppingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Credits"
        
        
        let creditImage = UIImage(named: "credits")
        let backgroundImage = UIImage(named: "credits_background")
        
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.sizeToFit()
        backgroundImageView.heightPercent = 100
        backgroundImageView.widthPercent = 100
        view.addSubview(backgroundImageView)
        
        let creditImageView = UIImageView(image: creditImage)
        creditImageView.sizeToFit()
        creditImageView.frame.origin = CGPointMake(60, 150)
        view.addSubview(creditImageView)

    }
}