//
//  TrainManager.swift
//  Metro
//
//  Created by yokota on 2014/10/18.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import MapKit

class TrainManager{
    var currentLocation:CLLocationCoordinate2D
    
    init(location :CLLocationCoordinate2D){
        self.currentLocation = location
    }
    
    func setLocation(lat:Double ,lon:Double){
        self.currentLocation.latitude = lat
        self.currentLocation.longitude = lon
    }
    
    func getNearTrains()->Bool{
        var geohash2station = JSON.fromURL("stationgaohash.json")
        let tmp:String = GeoHash.hashForLatitude(currentLocation.latitude, longitude: currentLocation.longitude, length: 7)
        var geohash = tmp
        print(geohash2station[geohash])
        return true
        
        
    }
}