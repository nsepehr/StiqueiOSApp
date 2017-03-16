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
    @IBAction func checkPressed(_ sender: AnyObject) {
        removeVocabulary()
        goNext()
    }
    @IBAction func minusPressed(_ sender: AnyObject) {
        keepVocabulary()
        goNext()
    }
    @IBAction func backPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any custom initialization here
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Master Study Background")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setting the correct orientation for this view
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        vocabularyLabel.text = items[count]["word"] as? String
        // For popping the app rater
        Appirater.userDidSignificantEvent(true)
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
            self.dismiss(animated: true, completion: nil)
        } else {
            vocabularyLabel.text = items[count]["word"] as? String
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            let vc = segue.destination as! StiqueVideoPlayer
            vc.item = items[count]
        }
    }
}


