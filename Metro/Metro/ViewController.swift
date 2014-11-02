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
        if !userDef.boolForKey("tutorial2") {
            NSLog("OK")
            let moveTutorial : TutorialViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tutorial") as TutorialViewController
            moveTutorial.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            
            self.presentViewController(moveTutorial, animated: true, completion: nil)
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

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func settings(sender: UIButton) {
        NSLog("configButtonPushed")
        let moveConfig :ConfViewController = self.storyboard?.instantiateViewControllerWithIdentifier("config") as ConfViewController
        moveConfig.modalPresentationStyle=UIModalPresentationStyle.OverFullScreen
        moveConfig.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
        self.presentViewController(moveConfig, animated: true, completion: nil)
    }
    
    //位置情報取得
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("OKOK \(locations)")
    }

}

