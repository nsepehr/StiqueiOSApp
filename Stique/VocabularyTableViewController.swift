//
//  VocabularyTableViewController.swift
//  Stique
//
//  Created by Nima Sepehr on 12/7/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

let segueToAVPlayer = "toAVController"

class VocabularyTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var item = StiqueData()
    let dataController = DataController()
    var ratings: StiqueRating?
    var player: AVPlayer?
    
    // Image for the ratings
    let starImage = UIImage(named: "Star New")
    let starBlankImage = UIImage(named: "Star Blank New")
    
    // The UI Outlet Objects
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var vocabularyLabel: UILabel!
    @IBOutlet weak var suffixLabel: UILabel!
    @IBOutlet weak var pronounciationLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    //@IBOutlet weak var masterStudyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    @IBOutlet weak var definitionTextArea: UITextView!
    @IBOutlet weak var exampleTextArea: UITextView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    // Stars Outlet Collection
    @IBOutlet var starRatings: [UIButton]!
    
    
    // The UI Action Objects
    @IBAction func backPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func speakerAction(_ sender: AnyObject) {
        playPronounciation()
    }
    /* NOTE: Taking this out and making automated when a user watches a video
    @IBAction func masterStudyPressed(_ sender: AnyObject) {
        addToMaster(item)
    }
    */
    @IBAction func sharePressed(_ sender: AnyObject) {
        sendEmailButtonTapped()
    }
    @IBAction func playlistPressed(_ sender: AnyObject) {
        addToPlaylist(item)
    }
    @IBAction func ratingAction(_ sender: AnyObject) {
        let rating: Int = sender.tag
        rateVideo(rating)
        let title = item["word"] as! String
        ratings![title] = rating
        dataController.updateRatings(ratings!)
        
        // Update the web database for the rating
        let baseURLString = "https://7t48nu4m33.execute-api.us-west-1.amazonaws.com/Development/testingPythonRDS"
        let postString = "{\"APIKey\": \"NayaTooBaba\", \"GUID\": \"12345\", \"Vocabulary\": \"\(title)\", \"Rating\": \"\(rating)\"}"
        let url = URL(string: baseURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("My returned data from web is: ")
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with request")
            }
        }
        task.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item["word"] as? String
        // Do any additional setup after loading the view, typically from a nib.
        
        //backgroundImageView.image = UIImage(named: "vocabulary_detail_background")
        //backgroundImageView.alpha = 0.25
        vocabularyLabel.text = item["word"] as? String
        suffixLabel.text = item["Suffix"] as? String
        pronounciationLabel.text = item["Pronounciation Text"] as? String
        speakerButton.setImage(UIImage(named: "Speaker"), for: UIControlState())
        //masterStudyButton.setImage(UIImage(named: "Master Study"), for: UIControlState())
        shareButton.setImage(UIImage(named: "Share"), for: UIControlState())
        playlistButton.setImage(UIImage(named: "Playlist"), for: UIControlState())
        definitionTextArea.text = item["Definition"] as? String
        exampleTextArea.text = item["Example"] as? String
        // Getting the image of the video thumbnail from URL
        let imageURL: String = item["Video Thumbnail"] as! String
        let imageNSURL: URL = URL(string: imageURL)!
        let imageData: Data? = try? Data(contentsOf: imageNSURL)
        if imageData != nil {
            videoImageView.image = UIImage(data: imageData!)
        } else {
            videoImageView.image = UIImage(named: "Cell Gear")
        }
        playButton.setImage(UIImage(named: "Cell Play"), for: UIControlState())
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the correct orientation
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Set the ratings
        ratings = dataController.getRatings()
        let title = item["word"] as! String
        if (ratings != nil && ratings![title] != nil) {
            let thisRating: Int = ratings![title]!
            rateVideo(thisRating)
        }
        
        // For popping the app rater
        Appirater.userDidSignificantEvent(true)
    }
    
    func setNavigationBar() {
        let backImage = UIImage(named: "back")
        let leftButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(VocabularyTableViewController.backButtonPressed))
        leftButton.title = " "
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func addToMaster(_ vocabulary: StiqueData) {
        self.dataController.addToMasterPlaylistData(vocabulary)
        /* No need to display an alert anymore
        let alert = UIAlertController(title: "Master Study", message: "Added to Master Study.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        */
    }
    
    func addToPlaylist(_ vocabulary: StiqueData) {
        let _self = self
        let playlists = dataController.getPlaylistData()
        if playlists.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please create a user playlist first, under the playlist tab.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Which playlist", message: "Which playlist to add to?", preferredStyle: .actionSheet)
            for playlist in playlists {
                let playlistName = (playlist["name"] as? String)!
                alert.addAction(UIAlertAction(title: playlistName, style: .default, handler: {(alert: UIAlertAction) in
                    print("Adding playlist with name: \(playlistName) ")
                    _self.dataController.addToUserPlaylist(vocabulary, playlist: playlistName)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
            self.present(mailComposeViewController, animated: true, completion: nil)
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
    
    func rateVideo(_ rating: Int) {
        // Loop through the needed stars to change image to full rated image
        for i in 0...starRatings.count-1 {
            let starButton = starRatings[i]
            if (i <= rating) {
                starButton.setImage(starImage, for: UIControlState())
            } else {
                starButton.setImage(starBlankImage, for: UIControlState())
            }
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func playPronounciation() {
        do {
            let url = URL(string: item["Pronounciation Audio"] as! String)!
            let playerItem = AVPlayerItem(url: url)
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToAVPlayer {
            let vc = segue.destination as! StiqueVideoPlayer
            vc.item = self.item
            self.dataController.addToMasterPlaylistData(self.item)
            self.dataController.addToWatchedList(self.item["word"] as! String)
        }
    }

}
