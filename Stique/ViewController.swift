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
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var item = [String: AnyObject]()
    var mainController = BaseController()
    var player: AVPlayer?
    var videoPlayer = AVPlayer()
    var playerController = PlayerViewController()
    
    deinit {    
        videoPlayer.removeObserver(self, forKeyPath: "rate")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        //view.backgroundColor = UIColor.greenColor()
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "Vocabulary_detail_background.png")!)
        let backgroundImage = UIImage(named: "Vocabulary_detail_background.png")
        let backgroundImageView = UIImageView(image: backgroundImage)
        view.addSubview(backgroundImageView)
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        let vocab = UILabel()
        vocab.text = item["word"] as? String
        vocab.font = UIFont.systemFontOfSize(26)
        vocab.adjustsFontSizeToFitWidth = true
        vocab.textAlignment = NSTextAlignment.Left
        view.addSubview(vocab)
        
        vocab.widthPercent = 50
//        vocab.marginTop = 70
        vocab.marginLeftAbsolute = 20
        vocab.height = 50
        
        let type = UILabel()
        type.text = item["Suffix"] as? String
        type.font = UIFont.italicSystemFontOfSize(12)
        type.textColor = UIColor.grayColor()
        view.addSubview(type)
        
        type.widthPercent = 20
        type.marginTopAbsolute = 5
        type.marginLeft = 10
        type.height = 50
        
        let speaker = UIButton()
        speaker.setImage(UIImage(named: "Speaker.png"), forState: .Normal)
//        speaker.setImage(UIImage(named: "Speaker.png"), forState: .)
        //speaker.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.VolumeUp), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(35)]), forState: .Normal)
        speaker.addTarget(self, action: Selector("play"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(speaker)
        
        speaker.widthPercent = 20
        speaker.marginTopAbsolute = 5
        speaker.marginRightAbsolute = 10
        speaker.height = 50

        
        let pronounce = UILabel()
        pronounce.text = item["Pronounciation Text"] as? String
        pronounce.font = UIFont.systemFontOfSize(12)
        pronounce.textColor = UIColor.grayColor()
        view.addSubview(pronounce)
        
        pronounce.widthPercent = 50
        pronounce.marginTopAbsolute = 50
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
        icon1.setImage(UIImage(named: "book.png"), forState: .Normal)
//        icon1.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Book), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icon1.addTarget(mainController, action: Selector("addToMaster"), forControlEvents: UIControlEvents.TouchUpInside)
        icons.addSubview(icon1)
        
        icon1.width = iconSize
        icon1.height = iconSize
        
        let icon2 = UIButton()
        icon2.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.List), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icon2.addTarget(mainController, action: Selector("addToPlaylist"), forControlEvents: UIControlEvents.TouchUpInside)
        icons.addSubview(icon2)
        
        icon2.width = iconSize
        icon2.marginLeft = 12
        icon2.height = iconSize
        
        let icon3 = UIButton()
        icon3.setAttributedTitle(NSAttributedString(string: String.fontAwesomeIconWithName(.Share), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)]), forState: .Normal)
        icon3.addTarget(self, action: #selector(sendEmailButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        let def1 = UITextView(frame: CGRectMake(20, def.frame.origin.y + 17, view.frame.width - 40, 40))
        def1.editable = false
        def1.text = item["Definition"] as? String
        def1.font = UIFont.systemFontOfSize(10.0)
        view.addSubview(def1)
        
        
        let def2 = UILabel()
        def2.text = "2. Definition is take from a dictionary"
        def2.font = UIFont.systemFontOfSize(10.0)
        def2.textAlignment = NSTextAlignment.Left
//        view.addSubview(def2)
        
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
        
        let ex1 = UITextView(frame: CGRectMake(20, ex.frame.origin.y + 17, view.frame.width - 40, 20))
        ex1.editable = false
        ex1.text = item["Example"] as? String
        ex1.font = UIFont.systemFontOfSize(10.0)
        view.addSubview(ex1)
        
        let rating = UILabel()
        rating.text = ""
        rating.font = UIFont.systemFontOfSize(12.0)
        rating.textAlignment = NSTextAlignment.Left
        view.addSubview(rating)
        
        rating.width = 50
        rating.marginTop = 10
        rating.marginRightAbsolute = 10
        rating.height = 15
        
        let video = UIView()
        let url = NSURL(string: item["Video URL"] as! String)
        video.backgroundColor = UIColor.grayColor()
        view.addSubview(video)
        
        video.widthPercent = 100
        video.marginTop = 5
        video.height = view.bounds.height - rating.frame.origin.y - rating.frame.height - 115
        
        videoPlayer = AVPlayer(URL: url!)
        playerController = PlayerViewController()
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        
//        playerController.showsPlaybackControls = true
        videoPlayer.seekToTime(CMTime(seconds: 2.5, preferredTimescale: 1))
        
        playerController.player = videoPlayer
        videoPlayer.addObserver(self, forKeyPath:"rate", options:.Initial, context:nil)
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "rate") {
            if videoPlayer.rate == 1.0 { // started playing
                let userDefaults = NSUserDefaults.standardUserDefaults()
                var watched = [item["word"] as! String]
                if let watched2 = userDefaults.objectForKey("watched_words") as? [String] {
                    watched += Array(Set(watched2)) // unique it
                }
                userDefaults.setObject(watched, forKey: "watched_words")
                userDefaults.synchronize()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //        mailComposerVC.setToRecipients(["nurdin@gmail.com"])
        mailComposerVC.setSubject("Sharing a Video With You")
        mailComposerVC.setMessageBody("Download the Stique app on iOS to view this cool video.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
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

