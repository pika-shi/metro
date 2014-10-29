//
//  ConfViewController.swift
//  Metro
//
//  Created by yokota on 2014/10/27.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import UIKit


class ConfViewController: UIViewController{
    

    @IBOutlet weak var finishButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func endConfig(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

