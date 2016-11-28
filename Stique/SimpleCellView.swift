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
    
    var playIcon = UIImageView()
    var label = UILabel()
    var rightButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        playIcon = UIImageView(frame: CGRectMake(5, 0, 50, 50))
        playIcon.image = UIImage(named: "cell_play")
        playIcon.contentMode = UIViewContentMode.ScaleAspectFit
//        icon.image = UIImage.fontAwesomeIconWithName(.YouTubePlay, textColor: UIColor(netHex:0x00443d), size: CGSizeMake(50, 50))
//        cell?.icon.image = UIImage.fontAwesomeIconWithName(type == 1 ? .PlayCircle : .Cog, textColor: UIColor.blackColor(), size: CGSizeMake(50, 50))
        //playIcon.image = UIImage(named: "play")
        label = UILabel(frame: CGRectMake(65, 0, 180, 50))
//        label.font = UIFont.systemFontOfSize(15.0)
        label.numberOfLines = 2
        
        
        contentView.addSubview(playIcon)
        contentView.addSubview(label)
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        let imageLeadConstraint = playIcon.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 20)
        imageLeadConstraint.active = true
        let imageTopConstraint  = playIcon.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 4)
        imageTopConstraint.active = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelLeadConstraint = label.leadingAnchor.constraintEqualToAnchor(playIcon.trailingAnchor, constant: 15)
        labelLeadConstraint.active = true
        let labelTopConstraint = label.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 15)
        labelTopConstraint.active = true
        
        
        
        //let screenSize: CGRect = UIScreen.mainScreen().bounds
        //rightButton = UIButton(frame: CGRectMake(screenSize.width - 50, 0, 50, 50))
        //rightButton.setTitle(String.fontAwesomeIconWithName(.EllipsisV), forState: UIControlState.Normal)
        //rightButton.setTitleColor(UIColor(netHex:0x01c0ad), forState: UIControlState.Normal)
        //rightButton.titleLabel?.font = UIFont.fontAwesomeOfSize(18)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let rightButton = UIButton(frame: CGRectMake(screenSize.width - 50, 0, 50, 50))
        rightButton.setImage(UIImage(named: "cell_options_oval"), forState: .Normal)
        contentView.addSubview(rightButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        let rightButtonTrailConstraint = rightButton.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: 10)
        rightButtonTrailConstraint.active = true
        //let rightButtonLeadConstraint = rightButton.leadingAnchor.constraintEqualToAnchor(label.trailingAnchor, constant: 20)
        //rightButtonLeadConstraint.active = true
        let rightButtonTopConstraint = rightButton.topAnchor.constraintEqualToAnchor(playIcon.topAnchor)
        rightButtonTopConstraint.active = true
        
        //textLabel?.textColor = UIColor(netHex:0x00443d)
        //backgroundColor = UIColor(netHex:0xfafdfd)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}