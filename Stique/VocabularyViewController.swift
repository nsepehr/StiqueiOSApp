//
//  ViewController.swift
//  Stique
//
//  Created by Nima Sepehr 2016
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

let segueToAVPlayer = "toAVController"

class VocabularyViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var item = StiqueData()
    let dataController = DataController()
    var player: AVPlayer?
    
    // The UI Outlet Objects
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var vocabularyLabel: UILabel!
    @IBOutlet weak var suffixLabel: UILabel!
    @IBOutlet weak var pronounciationLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var masterStudyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    @IBOutlet weak var definitionTextArea: UITextView!
    @IBOutlet weak var exampleTextArea: UITextView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    
    // The UI Action Objects
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func speakerAction(sender: AnyObject) {
        playPronounciation()
    }
    @IBAction func masterStudyPressed(sender: AnyObject) {
        addToMaster(item)
    }
    @IBAction func sharePressed(sender: AnyObject) {
        sendEmailButtonTapped()
    }
    @IBAction func playlistPressed(sender: AnyObject) {
        addToPlaylist(item)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item["word"] as? String
        // Do any additional setup after loading the view, typically from a nib.

        //backgroundImageView.image = UIImage(named: "vocabulary_detail_background")
        backgroundImageView.alpha = 0.25
        vocabularyLabel.text = item["word"] as? String
        suffixLabel.text = item["Suffix"] as? String
        pronounciationLabel.text = item["Pronounciation Text"] as? String
        speakerButton.setImage(UIImage(named: "Speaker"), forState: .Normal)
        masterStudyButton.setImage(UIImage(named: "master_study"), forState: .Normal)
        shareButton.setImage(UIImage(named: "share"), forState: .Normal)
        playlistButton.setImage(UIImage(named: "Playlist"), forState: .Normal)
        definitionTextArea.text = item["Definition"] as? String
        exampleTextArea.text = item["Example"] as? String
        // Getting the image of the video thumbnail from URL
        let imageURL: String = item["Video Thumbnail"] as! String
        let imageNSURL: NSURL = NSURL(string: imageURL)!
        let imageData: NSData? = NSData(contentsOfURL: imageNSURL)
        if imageData != nil {
            videoImageView.image = UIImage(data: imageData!)
        } else {
            videoImageView.image = UIImage(named: "cell_gear")
        }
        playButton.setImage(UIImage(named: "cell_play"), forState: .Normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set the correct orientation
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    func setNavigationBar() {
        let backImage = UIImage(named: "back")
        let leftButton = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: #selector(VocabularyViewController.backButtonPressed))
        leftButton.title = " "
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func backButtonPressed(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addToMaster(vocabulary: StiqueData) {
        self.dataController.addToMasterPlaylistData(vocabulary)
        let alert = UIAlertController(title: "Master Study", message: "Added to Master Study.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addToPlaylist(vocabulary: StiqueData) {
        let _self = self
        let playlists = dataController.getPlaylistData()
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Which playlist", message: "Which playlist to add to?", preferredStyle: .ActionSheet)
            for playlist in playlists {
                let playlistName = (playlist["name"] as? String)!
                alert.addAction(UIAlertAction(title: playlistName, style: .Default, handler: {(alert: UIAlertAction) in
                    print("Adding playlist with name: \(playlistName) ")
                    _self.dataController.addToUserPlaylist(vocabulary, playlist: playlistName)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            // Nima: Below was for before
            //let actionSheet = UIActionSheet(title: "Which Playlist To Add to?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            /*
             for myItem in playlists {
             let item = (myItem["name"] as? String)!
             actionSheet.addButtonWithTitle(item)
             }
             actionSheet.showInView(self.view)
             */
        }
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
    
    func playPronounciation() {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToAVPlayer {
            let vc = segue.destinationViewController as! StiqueVideoPlayer
            vc.item = self.item
        }
    }
}

