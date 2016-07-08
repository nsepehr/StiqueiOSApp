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
        
        icon = UIImageView(frame: CGRectMake(5, 0, 50, 50))
        icon.contentMode = UIViewContentMode.ScaleAspectFit
        icon.image = UIImage.fontAwesomeIconWithName(.YouTubePlay, textColor: UIColor(netHex:0x00443d), size: CGSizeMake(50, 50))
        
        label = UILabel(frame: CGRectMake(65, 0, 180, 50))
//        label.font = UIFont.systemFontOfSize(15.0)
        label.numberOfLines = 2
        
        
        contentView.addSubview(icon)
        contentView.addSubview(label)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        rightButton = UIButton(frame: CGRectMake(screenSize.width - 50, 0, 50, 50))
        rightButton.setTitle(String.fontAwesomeIconWithName(.EllipsisV), forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor(netHex:0x00443d), forState: UIControlState.Normal)
        rightButton.titleLabel?.font = UIFont.fontAwesomeOfSize(18)
        contentView.addSubview(rightButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}