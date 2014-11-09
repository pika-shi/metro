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
    var routeLat:Double!
    var routeLon:Double!
    
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
    
    @IBAction func locationHead(sender: AnyObject) {
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as CLLocation
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        println("\(lat) \(lon)")
        var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude:lon, zoom: 16)
        mapView.camera = camera
        var marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.title = "現在地"
        marker.snippet = "ここだよ〜"
        marker.map = mapView
        var stationCoordinate = stationManager.getNearStation(lat, lon: lon)
        var path:GMSMutablePath = GMSMutablePath()
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager()
        let requestSerializer:AFJSONRequestSerializer = AFJSONRequestSerializer()
        let responseSerializer:AFJSONResponseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer = responseSerializer
        manager.requestSerializer = requestSerializer
        manager.GET("http://pikashi.tokyo/lastre/getroute?gps_lat=\(lat)&gps_lon=\(lon)&station_lat=\(stationCoordinate.0)&station_lon=\(stationCoordinate.1)", parameters: nil,
            success: {(operation: NSURLSessionDataTask!, response: AnyObject!) in
                for coordinate in response.description.componentsSeparatedByString("\"")[1].componentsSeparatedByString(",") {
                    self.routeLat = NSString(string:coordinate.componentsSeparatedByString(":")[0]).doubleValue
                    self.routeLon = NSString(string:coordinate.componentsSeparatedByString(":")[1]).doubleValue
                    path.addCoordinate(CLLocationCoordinate2DMake(self.routeLat, self.routeLon))
                }
                var rectangle:GMSPolyline = GMSPolyline(path: path)
                rectangle.strokeWidth = 4;
                rectangle.map = self.mapView
        },
            failure: {(operation: NSURLSessionDataTask!, error: NSError!) in
                println("Error!!")
            }
        )
    }
}

