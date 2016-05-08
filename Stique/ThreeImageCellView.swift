//
//  SimpleCellView.swift
//  Speakeasier
//
//  Created by Soheil Yasrebi on 3/3/16.
//  Copyright © 2016 Soheil Yasrebi. All rights reserved.
//

import UIKit
import Foundation

class ThreeImageCellView : UITableViewCell {
    
    var icon1 = UIButton()
    var icon2 = UIButton()
    var icon3 = UIButton()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        let rv = RotatedView(frame: CGRectMake(20, 20, 50, 200))
//        foregroundView = rv
//        foregroundView.backgroundColor = UIColor.greenColor()
        //        self.containerView = UIView(frame: CGRect.zero)
        //        self.containerView.backgroundColor = UIColor.grayColor()
        //        self.containerView.constraints.append(FoldingCell::C)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        icon1 = UIButton(frame: CGRectMake(screenSize.width / 3 * 0 + 20, 15, 60, 25))
//        icon1.contentMode = UIViewContentMode.ScaleAspectFit
        icon1.setImage(UIImage(named: "gre"), forState: .Normal)
        contentView.addSubview(icon1)
        
        icon1 = UIButton(frame: CGRectMake(screenSize.width / 3 * 1 + 20, 15, 60, 25))
        icon1.contentMode = UIViewContentMode.ScaleAspectFit
        icon1.setImage(UIImage(named: "gmat"), forState: .Normal)
        contentView.addSubview(icon1)
        
        icon1 = UIButton(frame: CGRectMake(screenSize.width / 3 * 2 + 20, 15, 60, 25))
        icon1.contentMode = UIViewContentMode.ScaleAspectFit
        icon1.setImage(UIImage(named: "lsat"), forState: .Normal)
        contentView.addSubview(icon1)
        
//        label = UILabel(frame: CGRectMake(65, 0, 180, 50))
//        label.text = "hi"
//        //        label.font = UIFont.systemFontOfSize(15.0)
//        label.numberOfLines = 2
//        contentView.addSubview(label)
//
//        rightButton = UIButton(frame: CGRectMake(screenSize.width - 50, 0, 50, 50))
//        rightButton.setTitle(String.fontAwesomeIconWithName(.EllipsisV), forState: UIControlState.Normal)
//        rightButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        rightButton.titleLabel?.font = UIFont.fontAwesomeOfSize(18)
//        contentView.addSubview(rightButton)
//        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}