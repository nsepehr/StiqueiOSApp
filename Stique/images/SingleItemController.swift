//
//  SingleItemController.swift
//  Speakeasier
//
//  Created by Soheil Yasrebi on 3/4/16.
//  Copyright © 2016 Soheil Yasrebi. All rights reserved.
//

import UIKit
import Foundation

class SingleItemController: UIViewController {

    var item = [String: AnyObject]()
    var pic = UIImageView()
    var price = UILabel()
    var name = UILabel()
    var addBtn = UIButton()
    var plusBtn = UIButton()
    var minusBtn = UIButton()
    var count = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        var _price = 0.0
        if let priceString = item["price"] as? String {
            _price = Double(priceString)!
        } else {
            _price = item["price"] as! Double
        }
        var _count = 1
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let cart = userDefaults.arrayForKey("cart") as? [[String: AnyObject]] {
            for _item in cart {
                if (_item["name"] as? String) == (item["name"] as? String) {
                    _price = _item["price"] as! Double
                    _count = _item["count"] as! Int
                    break
                }
            }
        }
        
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: "leftButtonPressed")
//        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(16)] as Dictionary!
//        leftButton.setTitleTextAttributes(attributes, forState: .Normal)
//        leftButton.title = String.fontAwesomeIconWithName(.ArrowLeft)
//        
//        navigationItem.leftBarButtonItem = leftButton
        
        
        price.text = String(_price)
        price.textAlignment = NSTextAlignment.Right
        price.textColor = UIColor(netHex: 0x27ae60)
        price.font = UIFont.boldSystemFontOfSize(18)
        view.addSubview(price)

        
        pic.pin_setImageFromURL(NSURL(string: item["url"] as! String), placeholderImage: UIImage(), processorKey: "Ball", processor: { (result, cost) -> UIImage! in
            return result.image
        }, completion: { (result) -> Void in })
        view.addSubview(pic)
        
        
        name.text = item["name"] as? String
        name.textAlignment = NSTextAlignment.Center
        name.textColor = UIColor.grayColor()
        view.addSubview(name)
        
        
        addBtn.setTitle("               Add to Cart", forState: UIControlState.Normal)
        addBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addBtn.addTarget(self, action: "addBtnPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addBtn.backgroundColor = UIColor(netHex: 0x2ecc71)
        addBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        view.addSubview(addBtn)
        
        
        minusBtn = UIButton(frame: CGRectMake(10, 0, 30, 30))
        minusBtn.setTitle("–", forState: UIControlState.Normal)
        minusBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        minusBtn.addTarget(self, action: "minusBtnPressed", forControlEvents: UIControlEvents.TouchUpInside)
        minusBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        view.addSubview(minusBtn)
        
        count = UILabel(frame: CGRectMake(0, 0, 30, 30))
        count.text = String(_count)
        count.textColor = UIColor.whiteColor()
        count.backgroundColor = UIColor(netHex: 0x27ae60)
        count.font = UIFont.boldSystemFontOfSize(20)
        count.textAlignment = NSTextAlignment.Center
        view.addSubview(count)
        
        plusBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        plusBtn.setTitle("+", forState: UIControlState.Normal)
        plusBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        plusBtn.addTarget(self, action: "plusBtnPressed", forControlEvents: UIControlEvents.TouchUpInside)
        plusBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        view.addSubview(plusBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pic.marginTopAbsolute = 100
        pic.height = 150
        pic.widthPercent = 50
        price.marginTopAbsolute = 60
        price.height = 50
        price.width = 150
        price.marginRightAbsolute = 15
        name.marginTop = 20
        name.widthPercent = 80
        name.height = 50
        addBtn.widthPercent = 100
        addBtn.height = 50
        addBtn.marginBottomAbsolute = 0
        minusBtn.marginBottomAbsolute = 10
        plusBtn.marginBottomAbsolute = 10
        plusBtn.marginLeft = 10
        count.marginBottomAbsolute = 10
        count.marginLeft = 10
    }
    
    func addBtnPressed() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var _cart = [[String:AnyObject]]()
        var found = false
        if var cart = userDefaults.arrayForKey("cart") as? [[String: AnyObject]] {
            for (i, _item) in cart.enumerate() {
                if (_item["name"] as? String) == (item["name"] as? String) {
                    cart[i] = getItemInfo()
                    found = true
                    break
                }
            }
            _cart = cart
        }
        if !found {
            _cart.append(getItemInfo())
        }
        userDefaults.setValue(_cart, forKey: "cart")
        userDefaults.synchronize()

        navigationController?.popViewControllerAnimated(true)
    }
    
    func getItemInfo() -> [String:AnyObject] {
        return [
            "name": name.text!,
            "price": Double(price.text!)!,
            "count": Int(count.text!)!,
            "url": item["url"] as! String
        ]
    }
    
    func plusBtnPressed() {
        let cnt = Int(count.text!)!
        if cnt == 10 {
            plusBtn.enabled = false
            return
        }
        count.text = String(cnt + 1)
        minusBtn.enabled = true
    }
    
    func minusBtnPressed() {
        let cnt = Int(count.text!)!
        if cnt == 1 {
            minusBtn.enabled = false
            return
        }
        count.text = String(cnt - 1)
        plusBtn.enabled = true
    }
    
    func leftButtonPressed() {
        navigationController?.popViewControllerAnimated(true)
    }
}
