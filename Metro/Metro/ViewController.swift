//
//  ViewController.swift
//  Metro
//
//  Created by yokota on 2014/10/06.
//  Copyright (c) 2014年 job2. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var setting_button: UIButton!
    @IBOutlet weak var info_label: UILabel!
    
    var calloutView :SMCalloutView?
    let defaultRadius = 300
    
    
    var l_manager:CLLocationManager!
    
    override func viewDidAppear(animated: Bool) {
        var userDef = NSUserDefaults.standardUserDefaults()
        if !userDef.boolForKey("tutorial") {
            NSLog("OK")
            var moveTutorial : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("tutorial")
            self.presentViewController(moveTutorial as TutorialViewController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var userDef = NSUserDefaults.standardUserDefaults()
        if userDef.boolForKey("tutorial") {
           NSLog("NG")
        
        
        
        
        //現在地の情報を取得
        l_manager = CLLocationManager()
        l_manager.delegate = self
        l_manager.desiredAccuracy = kCLLocationAccuracyBest
        l_manager.requestAlwaysAuthorization()
        l_manager.distanceFilter = 300
        l_manager.startUpdatingLocation()
        
        
        
        
        var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(35.690667,longitude:139.7685037, zoom: 16)
        var mapView:GMSMapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.delegate = self
        mapView.myLocationEnabled = true
        self.view = mapView
        
        //マーカーをたてる
        let marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(35.690667, 139.7685037)
        marker.title = "現在地"
        marker.snippet = "ここだよ〜"
        marker.map = mapView
        }
    }

    func tutorial1(){
        var userDef = NSUserDefaults.standardUserDefaults()
        let view1 = self.view.viewWithTag(101)
        let label1 = UILabel()
        label1.text = "Hello!"
        info_label.text = "Hello!"
        view1?.addSubview(label1)
        userDef.setBool(true, forKey: "tutorial")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func settings(sender: UIButton) {
       
    }
    
    //位置情報取得
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("OKOK \(locations)")
    }

}

