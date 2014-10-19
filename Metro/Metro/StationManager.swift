//
//  StationManager.swift
//  Metro
//
//  Created by yokota on 2014/10/19.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import MapKit

public class StationManager{
    var currentLocation:CLLocationCoordinate2D!
    
    public init(_ location:CLLocationCoordinate2D){
        self.currentLocation = location
    }
    
    public func setLocation(lat:Double ,lon:Double){
        self.currentLocation.latitude = lat
        self.currentLocation.longitude = lon
    }
    
    public func getNearTrains()->Array<String>{
        var fpath = NSBundle.mainBundle().pathForResource("stationgeohash", ofType: "json")
        var data = NSData(contentsOfFile: fpath!)
        var gh_json:JSON = JSON.parse(NSString(data: data, encoding: NSUTF8StringEncoding))
        var geohash = GeoHash.hashForLatitude(currentLocation.latitude, longitude: currentLocation.longitude, length: 7)
        
        
        var nearStations:[String] = []
        //searchGeohashは集合として扱う
        var searchGeohash = Dictionary<String,Bool>()
        
        if let e = gh_json[geohash].asError{
            println("This geohash doesn't contain any stations.")
            println(e)
        }else{
            let stations:[JSON] = gh_json[geohash].asArray!
            for station in stations {
                nearStations.append(station.asString!)
            }
        }
        
        searchGeohash[geohash]=true
        for _ in 1...10 {
            if nearStations.count > 5 {
                break
            }
            for sgh in searchGeohash.keys {
                var ghn:GHNeighbors=GeoHash.neighborsForHash(sgh)
                searchGeohash[ghn.south]=true
                searchGeohash[ghn.southWest]=true
                searchGeohash[ghn.southEast]=true
                searchGeohash[ghn.north]=true
                searchGeohash[ghn.northWest]=true
                searchGeohash[ghn.northEast]=true
                searchGeohash[ghn.west]=true
                searchGeohash[ghn.east]=true
            }
            
            for gh in searchGeohash.keys {
                if let stations:[JSON] = gh_json[gh].asArray {
                    println("contain station in "+gh)
                    println(gh_json[gh].toString())
                    for station in stations {
                        nearStations.append(station.toString())
                    }
                }else{
                    let e = gh_json[gh].asError
                    println(gh+" doesn't contain any stations.")
                    println(e)
                }
            }
        }
        println("near stations are")
        println(nearStations)
        return nearStations
        
    }
}