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
    var startPosition:CGPoint!
    var lastTrainRestTime:Int!
    var departureRestTime:Int!
    var returnArray:Array<String>!
    

    @IBOutlet weak var currentLocationImage: UIImageView!
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
        
        mapView.delegate = self
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
        moveConfig.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
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
        var userDef = NSUserDefaults.standardUserDefaults()
        if userDef.boolForKey("track") {
            userDef.setBool(false, forKey: "track")
//            currentLocationImage.image = UIImage(named: "home_07")
        }else{
            userDef.setBool(true, forKey: "track")
            currentLocationImage.image = UIImage(named: "home_06")
            var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude:lon, zoom: 16)
            mapView.animateToCameraPosition(camera)
        }
    }
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        var userDef = NSUserDefaults.standardUserDefaults()
        if userDef.boolForKey("track"){
            var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude:lon, zoom: 16)
            mapView.animateToCameraPosition(camera)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userDef = NSUserDefaults.standardUserDefaults()
        location = locations.last as CLLocation
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        println("\(lat) \(lon)")
        if userDef.boolForKey("track"){
            var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude:lon, zoom: 16)
            mapView.camera = camera
        }
        var marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
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
                if !response.description.componentsSeparatedByString(";")[0].hasSuffix("notyet") {
                    path.removeAllCoordinates()
                    self.returnArray = response.description.componentsSeparatedByString("\"")[1].componentsSeparatedByString(",")
                    self.lastTrainRestTime = self.returnArray[0].toInt()!
                    self.departureRestTime = self.returnArray[1].toInt()!
                    for coordinate in Array(self.returnArray[2...self.returnArray.count-1]) {
                        self.routeLat = NSString(string:coordinate.componentsSeparatedByString(":")[0]).doubleValue
                        self.routeLon = NSString(string:coordinate.componentsSeparatedByString(":")[1]).doubleValue
                        path.addCoordinate(CLLocationCoordinate2DMake(self.routeLat, self.routeLon))
                    }
                    var rectangle:GMSPolyline = GMSPolyline(path: path)
                    rectangle.strokeWidth = 4;
                    rectangle.map = self.mapView
                }
            },
            failure: {(operation: NSURLSessionDataTask!, error: NSError!) in
                println("Error!!")
            }
        )
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {

        var userDef = NSUserDefaults.standardUserDefaults()
        let sw = userDef.boolForKey("track")
        NSLog("camera changed,iscamera=\(sw)")

        userDef.setBool(false, forKey: "track")
//        currentLocationImage.image = UIImage(named: "home_07")

    }

}

