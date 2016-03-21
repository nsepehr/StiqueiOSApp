//
//  CheckoutCellView.swift
//  Speakeasier
//
//  Created by Soheil Yasrebi on 3/8/16.
//  Copyright © 2016 Soheil Yasrebi. All rights reserved.
//

import UIKit
import Foundation

class CheckoutCellView : UITableViewCell {
    
    var count = UILabel()
    var label = UILabel()
    var price = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        count.font = UIFont.boldSystemFontOfSize(15)
        count.textAlignment = NSTextAlignment.Center
        count.textColor = UIColor.whiteColor()
        count.backgroundColor = UIColor(netHex: 0x27ae60)
        contentView.addSubview(count)
        
        label.font = UIFont.boldSystemFontOfSize(15)
        label.numberOfLines = 2
        label.textColor = UIColor.grayColor()
        contentView.addSubview(label)
        
        price.font = UIFont.boldSystemFontOfSize(15)
        price.textAlignment = NSTextAlignment.Center
        price.textColor = UIColor(netHex: 0x27ae60)
        contentView.addSubview(price)
        
        count.height = 22
        count.width = 22
        count.marginLeftAbsolute = 14
        count.marginTopAbsolute = 14
        label.height = 50
        label.widthPercent = 70
        label.marginLeft = 15
        price.width = 50
        price.height = 50
        price.marginRightAbsolute = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}