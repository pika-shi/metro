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
    

    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
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
            closeImage.alpha = 0
        }else{
            closeButton.alpha = 1
            closeImage.alpha = 1
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
    
    func stationNameValidate(stationName:String)->Bool{
        
        
        var filePath = NSBundle.mainBundle().pathForResource("stnamehash", ofType:"json")
        print(filePath)
        var data = NSData(contentsOfFile: filePath!)

        var json = JSON.parse(NSString(data:data!, encoding: NSUTF8StringEncoding) as String)

        println("length=\(json.length)")
        for key in json.generate() {
            if stationName == (key.0 as String){

                return true
            }
            let firstobj = key.1.asDictionary
            
            var romatmp:String? = firstobj?.values.first?.asString
            if romatmp != nil {
                println("in the parensis")
                println(romatmp)
                let romaName:String = split(romatmp!,{ $0 == "."})[3]
                if stationName.lowercaseString == romaName.lowercaseString{

                    return true
                }
            }
        }

        return false
    }
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    @IBAction func finishButton(sender: AnyObject) {
        SVProgressHUD.show()
        textview.hidden = true
        dispatch_async_global{
            var sw = self.stationNameValidate(self.textview.text)
            
            self.dispatch_async_main{
                if sw {
                    var userDef = NSUserDefaults.standardUserDefaults()
                    userDef.setBool(false, forKey: "firstconfig")
                    println(self.textview.text)
                    self.ud.setObject(self.textview.text, forKey: "station")
                    self.ud.synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self.errorLabel.text = "駅名を入力してください"
                }
                SVProgressHUD.dismiss()
                self.textview.hidden = false
            }
        }
        
        
    }
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

