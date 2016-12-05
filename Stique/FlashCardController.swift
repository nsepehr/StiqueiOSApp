//
//  ViewController.swift
//  Stique
//
//  Created by Nima Sepehr 2016.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import AVFoundation



class FlashCardController: UIViewController {
    
    var count = 0
    var items = [StiqueData]()
    let dataController = DataController()
    
    // UI Outlet Object
    @IBOutlet weak var vocabularyLabel: UILabel!
    
    // UI Action Object
    @IBAction func checkPressed(sender: AnyObject) {
        removeVocabulary()
        goNext()
    }
    @IBAction func minusPressed(sender: AnyObject) {
        keepVocabulary()
        goNext()
    }
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any custom initialization here
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Master Study Background")!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setting the correct orientation for this view
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        vocabularyLabel.text = items[count]["word"] as? String
    }
    
    func removeVocabulary () {
        // We will basically remove the item from the array and save the entire array
        //   This is not optimized, but works for our small app
        items = dataController.removeMasterPlaylistData(items, index: count)
    }
    
    func keepVocabulary () {
        // We don't really need to do anything here
        count += 1
    }
    
    func goNext () {
        if count == items.count {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            vocabularyLabel.text = items[count]["word"] as? String
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideo" {
            let vc = segue.destinationViewController as! StiqueVideoPlayer
            vc.item = items[count]
        }
    }
}


