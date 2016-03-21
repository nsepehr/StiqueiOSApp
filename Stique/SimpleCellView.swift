//
//  SimpleCellView.swift
//  Speakeasier
//
//  Created by Soheil Yasrebi on 3/3/16.
//  Copyright © 2016 Soheil Yasrebi. All rights reserved.
//

import UIKit
import Foundation

class SimpleCellView : UITableViewCell {
    
    var icon = UIImageView()
    var label = UILabel()
    var rightButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        let rv = RotatedView(frame: CGRectMake(20, 20, 50, 200))
//        foregroundView = rv
//        foregroundView.backgroundColor = UIColor.greenColor()
        //        self.containerView = UIView(frame: CGRect.zero)
        //        self.containerView.backgroundColor = UIColor.grayColor()
        //        self.containerView.constraints.append(FoldingCell::C)
        
        icon = UIImageView(frame: CGRectMake(10, 10, 90, 90))
        icon.contentMode = UIViewContentMode.ScaleAspectFit
        label = UILabel(frame: CGRectMake(110, 0, 180, 120))
        label.font = UIFont.systemFontOfSize(14.0)
        label.numberOfLines = 2

        
        contentView.addSubview(icon)
        contentView.addSubview(label)
        
        
        rightButton = UIButton(frame: CGRectMake(130, 10, 30, 30))
        rightButton.setTitle(String.fontAwesomeIconWithName(.EllipsisV), forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        rightButton.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
        contentView.addSubview(rightButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}