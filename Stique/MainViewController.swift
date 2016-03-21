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

class MainViewController: UITableViewController {
    
    var cellHeights = [CGFloat]()
    var TableData = [[String: AnyObject]]()
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
        let rightButton = UIBarButtonItem(title: "MY STASH", style: UIBarButtonItemStyle.Plain, target: self, action: "rightButtonPressed")
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: "leftButtonPressed")
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        leftButton.setTitleTextAttributes(attributes, forState: .Normal)
        leftButton.title = String.fontAwesomeIconWithName(.Bars)
        let attributesRight = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
        rightButton.setTitleTextAttributes(attributesRight, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Search)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Stique"
        
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
        do {
            let path = NSBundle.mainBundle().pathForResource("words", ofType: "json")
            let data: NSData? = NSData(contentsOfFile: path!)
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [[String: AnyObject]]
            if let jsonData = jsonData {
                TableData = jsonData
                tableView.reloadData()
            }
        } catch _ {
            // error handling
            print("error2")
        }
        
    }
    
    func leftButtonPressed() {
        slideMenuController()?.openLeft()
    }
    
    func rightButtonPressed() {
//        let vc = RightPanelController()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
//        navigationController?.pushViewController(s, animated: true)
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
        let myItem = TableData[indexPath.row]
        
        //        if cell == nil {
        //            cell = CellView()
        //        }
        
        //        cell.textLabel?.text = myItem["name"] as? String
        cell?.textLabel?.text = myItem["word"] as? String
        
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
        return cell!
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        footerView.backgroundColor = UIColor.whiteColor()
        
        orderBtn.setTitle("View Order", forState: UIControlState.Normal)
        orderBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        orderBtn.addTarget(self, action: "orderBtnPressed", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40//cellHeights[indexPath.row]
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
    
}

