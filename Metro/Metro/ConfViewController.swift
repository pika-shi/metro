//
//  ConfViewController.swift
//  Metro
//
//  Created by yokota on 2014/10/27.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import UIKit


class ConfViewController: UIViewController,UITextFieldDelegate{
    

    @IBOutlet weak var textview: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    let ud = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textview.returnKeyType = UIReturnKeyType.Done
        self.textview.delegate = self
        
        var userDef = NSUserDefaults.standardUserDefaults()
        if userDef.boolForKey("firstconfig"){
            closeButton.alpha = 0
        }else{
            closeButton.alpha = 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let station = ud.stringForKey("station") {
            self.textview.text = station
            println(self.textview.text)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textview.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stationNameValidate()->Bool{
        var filePath = NSBundle.mainBundle().pathForResource("Jsons", ofType:"txt")
        var data = NSData(contentsOfFile: filePath!)
        
        var json = JSON(NSString(data:data!, encoding: NSUTF8StringEncoding) as String)
        println(NSString(data:data!, encoding: NSUTF8StringEncoding) as String)
        return true
    }
    
    @IBAction func finishButton(sender: AnyObject) {
        if stationNameValidate() {
            var userDef = NSUserDefaults.standardUserDefaults()
            userDef.setBool(false, forKey: "firstconfig")
            println(self.textview.text)
            ud.setObject(self.textview.text, forKey: "station")
            ud.synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            
        }
    }
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

