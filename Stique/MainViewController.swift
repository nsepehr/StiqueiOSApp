//
//  MainViewController.swift
//  Stique
//
//  Created by Soheil Yasrebi on 3/21/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit
import FoldingCell
import PINRemoteImage
import MessageUI

class MainViewController: BaseController, MFMailComposeViewControllerDelegate {
    
    var cellHeights = [CGFloat]()
    var orderBtn = UIButton()
    var count = UILabel()
    var footerView = UIView()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var _count = 0
        if let cart = userDefaults.arrayForKey("cart") {
            footerView.hidden = cart.count == 0
            for item in cart {
                _count += item["count"] as! Int
            }
        }
        count.text = String(_count)
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...2 {
            cellHeights.append(10.0)
        }
        
        tableView.separatorColor = UIColor(netHex: 0xdedede)
        
        //        self.title = "Title"
        //
        //        let navigationBar = navigationController!.navigationBar
        //        navigationBar.tintColor = UIColor.blueColor()
        //
        //        let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        let rightButton = UIBarButtonItem(title: "MY STASH", style: UIBarButtonItemStyle.Plain, target: self, action: "rightButtonPressed")
//        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: "leftButtonPressed")
//        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
//        leftButton.setTitleTextAttributes(attributes, forState: .Normal)
//        leftButton.title = String.fontAwesomeIconWithName(.Bars)
//        let attributesRight = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
//        rightButton.setTitleTextAttributes(attributesRight, forState: .Normal)
//        rightButton.title = String.fontAwesomeIconWithName(.Search)
//        
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton
//        view.backgroundColor = UIColor.whiteColor()
//        
//        self.title = "Stique"
        
        //        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        //        navigationBar.backgroundColor = UIColor.grayColor()
        //        navigationBar.delegate = self
        
        
        //        self.view.addSubview(navigationBar)
        //        addLeftBarButtonWithImage(UIImage(named: "Icon-60")!)
        //        addRightBarButtonWithImage(UIImage(named: "Icon-60")!)
        //        self.slideMenuController()?.openLeft()
        
        //        view.addSubview(UIImageView(image: UIImage(named: "Icon")))
        
        
        //        let leftButton : UIBarButtonItem = UIBarButtonItem(title: "LeftButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        //        navigationItem.leftBarButtonItem = leftButton
        reloadData()
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
//    func leftButtonPressed() {
//        slideMenuController()?.openLeft()
//    }
//    
//    func rightButtonPressed() {
////        let vc = RightPanelController()
////        navigationController?.pushViewController(vc, animated: true)
//    }
    func reloadData() {
        
        
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        
//        userDefaults.setBool(!userDefaults.boolForKey("watched"), forKey: "watched")
//        userDefaults.setBool(!userDefaults.boolForKey("purchased"), forKey: "purchased")
//        userDefaults.setBool(!userDefaults.boolForKey("top"), forKey: "top")
        do {
            let path = NSBundle.mainBundle().pathForResource("words", ofType: "json")
            let data: NSData? = NSData(contentsOfFile: path!)
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [[String: AnyObject]]
            if let jsonData = jsonData {
                TableData = jsonData
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                if (userDefaults.boolForKey("sort")) {
                    TableData = TableData.reverse()
                }
                tableView.reloadData()
            }
        } catch _ {
            // error handling
            print("error2")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        indexPath2 = indexPath
        //
        //        var duration = 0.0
        //        if cellHeights[indexPath.row] == 10.0 { // open cell
        //            cellHeights[indexPath.row] = 30.0
        //            cell.selectedAnimation(true, animated: true, completion: nil)
        //            duration = 0.5
        //        } else {// close cell
        //            cellHeights[indexPath.row] = 30.0
        //            cell.selectedAnimation(false, animated: true, completion: nil)
        //            duration = 1.1
        //        }
        //
        //        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
        //            tableView.beginUpdates()
        //            tableView.endUpdates()
        //            }, completion: nil)
        
//        let s = SingleItemController()
//        s.item = TableData[indexPath.row]
        let vc = ViewController()
        
        if searchController.active && searchController.searchBar.text != "" {
            vc.item = FilteredTableData[indexPath.row]
        } else {
            vc.item = TableData[indexPath.row]
        }
        vc.mainController = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is FoldingCell {
            let foldingCell = cell as! FoldingCell
            
            if cellHeights[indexPath.row] == 10.0 {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    //
    //        let identifier = "Custom"
    //
    //        var cell: CellView! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CellView
    //
    //        if cell == nil {
    ////            tableView.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: identifier)
    ////            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CellView
    //            cell = CellView()
    //        }
    //        cell.textLabel?.text = "hi"
    //        cell.contentView.backgroundColor = UIColor.greenColor()
    //
    //        return cell
    //    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kLCellIdentifier = "customCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kLCellIdentifier) as! SimpleCellView!
        if cell == nil {
//            cell = SimpleCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
            cell = SimpleCellView(style:.Default, reuseIdentifier: kLCellIdentifier)
        }
        var myItem = [String: AnyObject]()
        if searchController.active && searchController.searchBar.text != "" {
            myItem = FilteredTableData[indexPath.row]
        } else {
            myItem = TableData[indexPath.row]
        }
        //        if cell == nil {
        //            cell = CellView()
        //        }
        
        //        cell.textLabel?.text = myItem["name"] as? String
        cell?.label.text = myItem["word"] as? String
        
//        let url = myItem["url"] as! String
        //        cell.imageView?.pin_setImageFromURL(NSURL(string: url), placeholderImage: UIImage(), processorKey: "Ball", processor: { (result, cost) -> UIImage! in
        //            return result.image
        //
        //            }, completion: { (result) -> Void in })
        //        cell.detailTextLabel?.text = myItem["name"] as? String
        
        //        cell.imageView!
        //        let v = UIImageView(frame: CGRectMake(0, 0, 90, 90))
        //        v.backgroundColor = UIColor.yellowColor()
        
//        cell.icon.pin_setImageFromURL(NSURL(string: url), placeholderImage: UIImage(), processorKey: "Ball", processor: { (result, cost) -> UIImage! in
//            return result.image
        
//            }, completion: { (result) -> Void in })
        //        cell.contentView.addSubview(v)
        cell.rightButton.addTarget(self, action: #selector(rightCellButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell!
    }
    
    func rightCellButtonPressed(button: UIButton) {
        indexPath2 = tableView.indexPathForCell(button.superview?.superview as! UITableViewCell)!
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Add to Master Study", "Share", "Add to Playlist")
        
        actionSheet.showInView(self.view)
//        let controller = UIMenuController.sharedMenuController()
//        let textItem1 = UIMenuItem(title: "Add to study", action: #selector(contextButton1))
//        let textItem2 = UIMenuItem(title: "Share", action: #selector(contextButton2))
//        let textItem3 = UIMenuItem(title: "Add to playlist", action: #selector(contextButton3))
//        let image = UIImage(named: "Image")!
//        let imageItem = UIMenuItem(image: image) { [weak self] _ in
//            self?.showAlertWithTitle("image item tapped")
//        }
//        
//        let nextItem = UIMenuItem(title: "Show More Items...") { _ in
//            let handler: MenuItemHandler = { [weak self] in self?.showAlertWithTitle($0.title + " tapped") }
//            let item1 = UIMenuItem(title: "1", handler: handler)
//            let item2 = UIMenuItem(title: "2", handler: handler)
//            let item3 = UIMenuItem(title: "3", handler: handler)
//            controller.menuItems = [item1, item2, item3]
//            controller.setMenuVisible(true, animated: true)
//        }
//        
//        controller.menuItems = [textItem1, textItem2, textItem3]
//        controller.setTargetRect(button.bounds, inView: button)
//        controller.setMenuVisible(true, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if isAddingToPlaylist {
            isAddingToPlaylist = false
            addToUserPlaylist(buttonIndex)
        } else {
            if buttonIndex == 1 {
                addToMaster()
            } else if buttonIndex == 2 {
                sendEmailButtonTapped()
            } else if buttonIndex == 3 {
                addToPlaylist()
            }
        }
    }
    
    func contextButton1() {
        
    }
    
    func contextButton2() {
        
    }
    
    func contextButton3() {
        
    }
    
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        footerView.backgroundColor = UIColor.whiteColor()
        
        orderBtn.setTitle("View Order", forState: UIControlState.Normal)
        orderBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        orderBtn.addTarget(self, action: #selector(orderBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        orderBtn.backgroundColor = UIColor(netHex: 0x2ecc71)
        orderBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        footerView.addSubview(orderBtn)
        
        count = UILabel(frame: CGRectMake(0, 0, 30, 30))
        count.textColor = UIColor.whiteColor()
        count.backgroundColor = UIColor(netHex: 0x27ae60)
        count.font = UIFont.boldSystemFontOfSize(20)
        count.textAlignment = NSTextAlignment.Center
        footerView.addSubview(count)
        
        footerView.hidden = true
        return footerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        orderBtn.widthPercent = 100
        orderBtn.height = 50
        orderBtn.marginBottomAbsolute = 0
        count.marginBottomAbsolute = 10
        count.marginLeftAbsolute = 10
    }
    
    func orderBtnPressed() {
//        let orderController = OrderController()
//        let nav = UINavigationController(rootViewController: orderController)
//        presentViewController(nav, animated: true, completion: nil)
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
}
