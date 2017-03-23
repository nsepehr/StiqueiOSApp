//
//  ViewController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/25/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class GeneralNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Override go below
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override open var shouldAutorotate : Bool {
        get {
            return false
        }
    }
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                if visibleVC.isKind(of: FlashCardController.classForCoder()) {
                    return UIInterfaceOrientation.landscapeLeft
                } else {
                    return UIInterfaceOrientation.portrait
                }
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                if visibleVC.isKind(of: FlashCardController.classForCoder()) {
                    print("Supported interface for flash should only be landscape")
                    return UIInterfaceOrientationMask.landscape
                } else {
                    return UIInterfaceOrientationMask.portrait
                }
            }
            return super.supportedInterfaceOrientations
        }
    }
}


