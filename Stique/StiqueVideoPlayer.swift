//
//  StiqueVideoPlayer.swift
//  Stique
//
//  Created by Nima Sepehr on 11/30/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class StiqueVideoPlayer: AVPlayerViewController {
    
    var item = StiqueData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: item["Video URL"] as! String)
        let videoPlayer = AVPlayer(url: url!)
        //videoPlayer.seek(to: CMTime(seconds: 3, preferredTimescale: 1)) --> We're starting from beginning of video
        self.player = videoPlayer
        
        // Below is a snippet taken from online for ignoring the mute switch for video/audio playback
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            //Didn't work
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the correct orientation
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        navigationController?.hidesBarsOnTap = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.player?.play()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        navigationController?.hidesBarsOnTap = false
        tabBarController?.tabBar.isHidden = false
    }

}





/*
 deinit {
 videoPlayer.removeObserver(self, forKeyPath: "rate")
 }
 */


/*
 let video = UIView()
 let url = NSURL(string: item["Video URL"] as! String)
 video.backgroundColor = UIColor.grayColor()
 view.addSubview(video)
 
 video.widthPercent = 100
 video.height = 150
 video.sizeToFit()
 video.frame.origin = CGPointMake(0, 370)
 //video.height = view.bounds.height - rating.frame.origin.y - rating.frame.height - 115
 
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
 
 */


/*
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
 */
