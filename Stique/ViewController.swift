//
//  ViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/15/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

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
        
        vocab.marginTop = 70
        vocab.marginLeft = 10
        vocab.widthPercent = 60
        vocab.height = 50
        
        let type = UILabel()
        type.text = "adjective"//item["type"] as? String
        type.font = UIFont.italicSystemFontOfSize(12)
        type.textColor = UIColor.grayColor()
        view.addSubview(type)
        
        type.marginTopAbsolute = 75
        type.marginLeft = 10
        type.widthPercent = 20
        type.height = 50
        
        let pronounce = UILabel()
        pronounce.text = "/'Pronounciation/"//item["type"] as? String
        pronounce.font = UIFont.systemFontOfSize(12)
        pronounce.textColor = UIColor.grayColor()

        view.addSubview(pronounce)
        
        pronounce.marginTop = 10
        pronounce.marginLeftAbsolute = 10
        pronounce.widthPercent = 50
        pronounce.height = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

