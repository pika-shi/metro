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
    @IBOutlet weak var mapView: GMSMapView!
    var calloutView :SMCalloutView?
    let defaultRadius = 300
    var stationManager:StationManager!
    var location:CLLocation!
    var l_manager:CLLocationManager!
    var lat:Double!
    var lon:Double!
    
    override func viewDidAppear(animated: Bool) {
        var userDef = NSUserDefaults.standardUserDefaults()
        if !userDef.boolForKey("tutorial") {
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
        }
        
        l_manager = CLLocationManager()
        l_manager.delegate = self
        l_manager.desiredAccuracy = kCLLocationAccuracyBest
        l_manager.requestAlwaysAuthorization()
        l_manager.distanceFilter = 300
        
        stationManager = StationManager()
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
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Authorized {
            l_manager.startUpdatingLocation()
        }
    }
    
    @IBAction func moveToTutorial(sender: AnyObject) {
        NSLog("button pushed")
        let moveTutorial : TutorialViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tutorial") as TutorialViewController
        moveTutorial.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
        
        self.presentViewController(moveTutorial, animated: true, completion: nil)
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as CLLocation
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        println("\(lat) \(lon)")
        var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude:lon, zoom: 17)
        mapView.camera = camera
        var marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.title = "現在地"
        marker.snippet = "ここだよ〜"
        marker.map = mapView
        var stationCoordinate = stationManager.getNearStation(lat, lon: lon)
        var path:GMSMutablePath = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2DMake(lat,lon))
        path.addCoordinate(CLLocationCoordinate2DMake(stationCoordinate.0,stationCoordinate.1))
        var rectangle:GMSPolyline = GMSPolyline(path: path)
        rectangle.strokeWidth = 5;
        rectangle.map = mapView
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager()
        let requestSerializer:AFJSONRequestSerializer = AFJSONRequestSerializer()
        let responseSerializer:AFJSONResponseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer = responseSerializer
        manager.requestSerializer = requestSerializer
        manager.GET("http://maps.googleapis.com/maps/api/directions/json?origin=\(lat),\(lon)&destination=\(stationCoordinate.0),\(stationCoordinate.1)&sensor=false", parameters: nil,
            success: {(operation: NSURLSessionDataTask!, response: AnyObject!) in
                println(response.description.stringByReplacingOccurrencesOfString("(", withString: "[", options: nil, range: nil).stringByReplacingOccurrencesOfString(")", withString: "]", options: nil, range: nil))
                var directionsJson:JSON = JSON.parse(response.description.stringByReplacingOccurrencesOfString("(", withString: "[", options: nil, range: nil).stringByReplacingOccurrencesOfString(")", withString: "]", options: nil, range: nil))
                //println(directionsJson["routes"].asString)
                println("http://maps.googleapis.com/maps/api/directions/json?origin=\(self.lat),\(self.lon)&destination=\(stationCoordinate.0),\(stationCoordinate.1)&sensor=false")

            },
            failure: {(operation: NSURLSessionDataTask!, error: NSError!) in
                println("Error!!")
            }
        )
    }

}

