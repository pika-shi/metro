//
//  ViewController.swift
//  Metro
//
//  Created by yokota on 2014/10/06.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var setting_button: UIButton!
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var map_view: MKMapView!
    
    var l_manager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //現在地の情報を取得
        l_manager = CLLocationManager()
        l_manager.delegate = self
        l_manager.desiredAccuracy = kCLLocationAccuracyBest
        l_manager.requestAlwaysAuthorization()
        l_manager.startUpdatingLocation()
        
        
        self.map_view.delegate = self
        //初期位置を設定
        //経度、緯度からメルカトル図法の点に変換する
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213,139.730011)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        self.map_view.setRegion(centerPosition,animated:true)
        
        //出発点：六本木　〜　目的地：渋谷
        //経度、緯度からメルカトル図法の点に変換する
        var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213, 139.730011)
        var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.658987, 139.702776)
        
        //CLLocationCoordinate2DからMKPlacemarkを作成する
        var fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        var toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        
        //MKPlacemarkからMKMapItemを生成します。
        var fromItem = MKMapItem(placemark:fromPlacemark);
        var toItem = MKMapItem(placemark:toPlacemark);
        
        //MKMapItem をセットして MKDirectionsRequest を生成します
        let request = MKDirectionsRequest()
        request.setSource(fromItem)
        request.setDestination(toItem)
        request.requestsAlternateRoutes = true; //複数経路
        request.transportType = MKDirectionsTransportType.Walking //移動手段 Walking:徒歩/Automobile:車
        
        //経路を検索する(非同期で実行される)
        let directions = MKDirections(request:request)
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            if ((error != nil) || response.routes.isEmpty) {
                return
            }
            if (response.routes.isEmpty){
                return
            }
            let route: MKRoute = response.routes[0] as MKRoute
            self.map_view.addOverlay(route.polyline!)
        })
        
        //アノテーションというピンを地図に刺すことができる
        //出発点：六本木　〜　目的地：渋谷　の２点に刺す
        var theRoppongiAnnotation = MKPointAnnotation()
        theRoppongiAnnotation.coordinate  = fromCoordinate
        theRoppongiAnnotation.title       = "Roppoingi"
        theRoppongiAnnotation.subtitle    = "xxxxxxxxxxxxxxxxxx"
        self.map_view.addAnnotation(theRoppongiAnnotation)
        
        var theShibuyaAnnotation = MKPointAnnotation()
        theShibuyaAnnotation.coordinate  = toCoordinate
        theShibuyaAnnotation.title       = "Shibuya"
        theShibuyaAnnotation.subtitle    = "xxxxxxxxxxxxxxxxxx"
        self.map_view.addAnnotation(theShibuyaAnnotation)
        
        //カメラの設定をしてみる（少し手前に傾けた状態）
        var camera:MKMapCamera = self.map_view.camera;
        //camera.altitude += 100
        //camera.heading += 15
        camera.pitch += 60
        self.map_view.setCamera(camera, animated: true)
        self.map_view.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func settings(sender: UIButton) {
        var url = NSURL(scheme: "http", host: "localhost:8000", path: "/metron")
//        var request = NSURLRequest(URL: url)
//        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//        var json = JSON(data!)
        var json = JSON.fromNSURL(url)
        var str:String = json.toString(pretty: true)
        self.info_label.text = json.toString(pretty: false)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
    
    //位置情報取得
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("OKOK \(locations)")
    }

}

