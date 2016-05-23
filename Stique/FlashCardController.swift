//
//  ViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/15/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVFoundation

class FlashCardController: UIViewController {
    
    var item = [String: AnyObject]()
    var blackbar = UIView()
    var mainController = BaseController()
    var player: AVPlayer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        blackbar.backgroundColor = UIColor.blackColor()
        blackbar.frame = CGRectMake(0, 0, view.frame.width, 80)
        self.tabBarController?.tabBar.addSubview(blackbar)
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card = UIView()
        card.frame = CGRectMake(0, 0, view.frame.width, view.frame.height/2)
        card.backgroundColor = UIColor.whiteColor()
        
        
        let vocab = UILabel()
        vocab.text = item["word"] as? String
        vocab.font = UIFont.systemFontOfSize(26)
        vocab.textAlignment = NSTextAlignment.Left
        card.addSubview(vocab)
        
        vocab.widthPercent = 40
        vocab.marginTop = 70
        vocab.marginLeft = 20
        vocab.height = 50
        
        let type = UILabel()
        type.text = item["Suffix"] as? String
        type.font = UIFont.italicSystemFontOfSize(12)
        type.textColor = UIColor.grayColor()
        card.addSubview(type)
        
        type.widthPercent = 20
        type.marginTopAbsolute = 75
        type.marginLeft = 10
        type.height = 50
        
        
        let exit = UIButton()
        exit.setTitle("Exit", forState: .Normal)
        exit.setTitleColor(UIColor.blueColor(), forState: .Normal)
        exit.addTarget(self, action: #selector(exitFunc), forControlEvents: UIControlEvents.TouchUpInside)
        card.addSubview(exit)
        
        exit.width = 70
        exit.marginLeftAbsolute = 20
        exit.height = 30
        exit.marginTop = 10
        
        let viewBtn = UIButton()
        viewBtn.setTitle("View", forState: .Normal)
        viewBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        viewBtn.addTarget(self, action: #selector(viewFunc), forControlEvents: UIControlEvents.TouchUpInside)
        card.addSubview(viewBtn)
        
        viewBtn.width = 70
        viewBtn.marginLeftAbsolute = 20
        viewBtn.height = 30
        viewBtn.marginTop = 10
        
        let xBtn = UIButton()
        xBtn.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Close), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        xBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        xBtn.addTarget(self, action: #selector(x), forControlEvents: UIControlEvents.TouchUpInside)
        card.addSubview(xBtn)
        
        xBtn.width = 70
        xBtn.marginLeftAbsolute = 20
        xBtn.height = 30
        xBtn.marginTop = 10
        
        let okBtn = UIButton()
        okBtn.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Check), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        okBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        okBtn.addTarget(self, action: #selector(ok), forControlEvents: UIControlEvents.TouchUpInside)
        card.addSubview(okBtn)
        
        okBtn.width = 70
        okBtn.marginRightAbsolute = 20
        okBtn.height = 30
        okBtn.marginTop = -30
        
        let speaker = UIButton()
        speaker.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.VolumeUp), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        speaker.addTarget(self, action: Selector("play"), forControlEvents: UIControlEvents.TouchUpInside)
        card.addSubview(speaker)
        
        speaker.widthPercent = 20
        speaker.marginTopAbsolute = 75
        speaker.marginRightAbsolute = 10
        speaker.height = 50
        
        view.addSubview(card)
        
    }
    
    func x() {
        nextOrQuit()
    }
    
    func ok() {
        true
        mainController.removeItem(mainController.indexPath2)
        nextOrQuit()
    }
    
    func nextOrQuit() {
        mainController.goNext = mainController.TableData.count > mainController.indexPath2.row + 1
        exitFuncWithAnimation(!mainController.goNext)
    }
    
    func exitFunc() {
        exitFuncWithAnimation(true)
    }
    
    func exitFuncWithAnimation(animated: Bool) {
        blackbar.removeFromSuperview()
        self.navigationController?.navigationBar.hidden = false
        
        navigationController?.popViewControllerAnimated(animated)
    }
    
    func viewFunc() {
        blackbar.removeFromSuperview()
        self.navigationController?.navigationBar.hidden = false
        
        let vc = ViewController()
        vc.item = item
        vc.mainController = mainController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addToPlaylist() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var TableData = [[String: AnyObject]]()
        TableData = [item]
        do {
            if let playlist = userDefaults.stringForKey("playlist1") {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(playlist.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    TableData += jsonData
                }
            }
            let jsonData2 = try NSJSONSerialization.dataWithJSONObject(TableData, options: NSJSONWritingOptions.PrettyPrinted)
            userDefaults.setObject(NSString(data: jsonData2, encoding: NSASCIIStringEncoding), forKey: "playlist1")
            userDefaults.synchronize()
        } catch _ {}
    }
    
    func play() {
        do {
            let url = NSURL(string: item["Pronounciation Audio"] as! String)!
            let playerItem = AVPlayerItem(URL: url)
            
            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}

