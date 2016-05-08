//
//  ViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/15/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var item = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        view.backgroundColor = UIColor.whiteColor()
        
        let vocab = UILabel()
        vocab.text = item["word"] as? String
        vocab.font = UIFont.systemFontOfSize(26)
        vocab.textAlignment = NSTextAlignment.Left
        view.addSubview(vocab)
        
        vocab.widthPercent = 40
        vocab.marginTop = 70
        vocab.marginLeft = 20
        vocab.height = 50
        
        let type = UILabel()
        type.text = "adjective"//item["type"] as? String
        type.font = UIFont.italicSystemFontOfSize(12)
        type.textColor = UIColor.grayColor()
        view.addSubview(type)
        
        type.widthPercent = 20
        type.marginTopAbsolute = 75
        type.marginLeft = 10
        type.height = 50
        
        let speaker = UIButton()
        speaker.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.VolumeUp), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        view.addSubview(speaker)
        
        speaker.widthPercent = 20
        speaker.marginTopAbsolute = 75
        speaker.marginRightAbsolute = 10
        speaker.height = 50

        
        let pronounce = UILabel()
        pronounce.text = "/'Pronounciation/"//item["type"] as? String
        pronounce.font = UIFont.systemFontOfSize(12)
        pronounce.textColor = UIColor.grayColor()
        view.addSubview(pronounce)
        
        pronounce.widthPercent = 50
        pronounce.marginTopAbsolute = 120
        pronounce.marginLeftAbsolute = 20
        pronounce.height = 20
        
        let icons = UIView()
        view.addSubview(icons)
        
        icons.widthPercent = 30
        icons.marginTop = 5
        icons.marginRightAbsolute = 5
        icons.height = 22
        
        let iconSize = CGFloat(20)
        
        let icon1 = UIButton()
        icon1.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Book), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icons.addSubview(icon1)
        
        icon1.width = iconSize
        icon1.height = iconSize
        
        let icon2 = UIButton()
        icon2.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.List), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icons.addSubview(icon2)
        
        icon2.width = iconSize
        icon2.marginLeft = 12
        icon2.height = iconSize
        
        let icon3 = UIButton()
        icon3.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Share), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icons.addSubview(icon3)
        
        icon3.width = iconSize
        icon3.marginLeft = 12
        icon3.height = iconSize
        
        let line = UIView()
        view.addSubview(line)
        line.backgroundColor = UIColor.grayColor()
        line.widthPercent = 100
        line.marginTop = 8
        line.height = 2
        
        let def = UILabel()
        def.text = "Definition:"
        def.font = UIFont.init(name: "Arial-BoldItalicMT", size: 12.0)
        def.textAlignment = NSTextAlignment.Left
        view.addSubview(def)
        
        def.widthPercent = 40
        def.marginTop = 17
        def.marginLeftAbsolute = 20
        def.height = 12
        
        let def1 = UILabel()
        def1.text = "1. Here we will put the definition for each word"
        def1.font = UIFont.systemFontOfSize(10.0)
        def1.textAlignment = NSTextAlignment.Left
        view.addSubview(def1)
        
        def1.widthPercent = 100
        def1.marginTop = 17
        def1.marginLeftAbsolute = 20
        def1.height = 10
        
        let def2 = UILabel()
        def2.text = "2. Definition is take from a dictionary"
        def2.font = UIFont.systemFontOfSize(10.0)
        def2.textAlignment = NSTextAlignment.Left
        view.addSubview(def2)
        
        def2.widthPercent = 100
        def2.marginTop = 17
        def2.marginLeftAbsolute = 20
        def2.height = 10
        
        let line2 = UIView()
        view.addSubview(line2)
        line2.backgroundColor = UIColor.grayColor()
        line2.widthPercent = 98
        line2.marginLeftAbsolute = 20
        line2.marginTop = 35
        line2.height = 1
        
        let ex = UILabel()
        ex.text = "Example:"
        ex.font = UIFont.init(name: "Arial-BoldItalicMT", size: 12.0)
        ex.textAlignment = NSTextAlignment.Left
        view.addSubview(ex)
        
        ex.widthPercent = 40
        ex.marginTop = 17
        ex.marginLeftAbsolute = 20
        ex.height = 12
        
        let ex1 = UILabel()
        ex1.text = "1. Here we will put the example"
        ex1.font = UIFont.systemFontOfSize(10.0)
        ex1.textAlignment = NSTextAlignment.Left
        view.addSubview(ex1)
        
        ex1.widthPercent = 100
        ex1.marginTop = 17
        ex1.marginLeftAbsolute = 20
        ex1.height = 10
        
        let rating = UILabel()
        rating.text = "[Rating]"
        rating.font = UIFont.systemFontOfSize(12.0)
        rating.textAlignment = NSTextAlignment.Left
        view.addSubview(rating)
        
        rating.width = 50
        rating.marginTop = 10
        rating.marginRightAbsolute = 10
        rating.height = 15
        
        let video = UIView()
        let url = NSURL(string: "https://s3-us-west-1.amazonaws.com/smvtestvideotranscoded/01-Exigent.mp4")
        video.backgroundColor = UIColor.grayColor()
        view.addSubview(video)
        
        video.widthPercent = 100
        video.marginTop = 5
        video.height = view.bounds.height - rating.frame.origin.y - rating.frame.height - 50
        
        let player = AVPlayer(URL: url!)
        let playerController = PlayerViewController()
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        
//        playerController.showsPlaybackControls = false
        player.seekToTime(CMTime(seconds: 2.0, preferredTimescale: 1))
        
        playerController.player = player
        self.addChildViewController(playerController)
        video.addSubview(playerController.view)
        //        playerController.view.frame = video.frame
        playerController.view.widthPercent = 100
        playerController.view.heightPercent = 100
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
        print("---------------------")
//        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

