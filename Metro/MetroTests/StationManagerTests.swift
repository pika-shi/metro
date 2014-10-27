//
//  TrainManagerTests.swift
//  Metro
//
//  Created by yokota on 2014/10/19.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import XCTest
import MapKit
import Metro

class StationManagerTests: XCTestCase {
    var st:StationManager!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        st=StationManager(CLLocationCoordinate2DMake(35.690667,139.7685037))
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        NSLog("testExample")
            
    }
    
}
