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
    
    @IBAction func finishButton(sender: AnyObject) {
        println(self.textview.text)
        ud.setObject(self.textview.text, forKey: "station")
        ud.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

